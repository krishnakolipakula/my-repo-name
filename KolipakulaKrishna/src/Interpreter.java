import java.util.*;

public class Interpreter extends delphiBaseVisitor<Object> {

    static class BreakSignal extends RuntimeException {}
    static class ContinueSignal extends RuntimeException {}

    static class InterfaceDef {
        String name;
        Set<String> requiredMethods = new HashSet<>();
    }

    static class RoutineDef {
        String name;
        List<String> params = new ArrayList<>();
        delphiParser.BlockContext block;
        boolean function;
    }

    static class ClassDef {
        String name;
        String superName;
        List<delphiParser.FieldDeclContext> fields = new ArrayList<>();
        Map<String, Boolean> fieldVisibility = new HashMap<>(); // true = private
        delphiParser.ConstructorDeclContext constructor;
        delphiParser.DestructorDeclContext destructor;
        Map<String, delphiParser.MethodDeclContext> methods = new HashMap<>();
    }

    static class Instance {
        ClassDef klass;
        Map<String, Object> fields = new HashMap<>();
        Instance(ClassDef k) { klass = k; }
    }

    private final Map<String, InterfaceDef> interfaces = new HashMap<>();
    private final Map<String, RoutineDef> routines = new HashMap<>();
    private final Map<String, ClassDef> classes = new HashMap<>();
    private final Map<String, Object> globals = new HashMap<>();
    private final List<Instance> allInstances = new ArrayList<>();
    private final Deque<Map<String,Object>> scopes = new ArrayDeque<>();
    private Instance currentThis = null;
    private final Scanner scanner = new Scanner(System.in);
    private final boolean printOptimizedAst = Boolean.parseBoolean(System.getProperty("printAst", "false"));

    static class FoldResult {
        final boolean isIntConst;
        final Integer intValue;
        final String text;

        FoldResult(boolean isIntConst, Integer intValue, String text) {
            this.isIntConst = isIntConst;
            this.intValue = intValue;
            this.text = text;
        }
    }

    private void pushScope() {
        scopes.push(new HashMap<>());
    }

    private void popScope() {
        scopes.pop();
    }

    private void declareVariable(String id, Object value) {
        if (!scopes.isEmpty()) scopes.peek().put(id, value);
        else globals.put(id, value);
    }

    private boolean assignToExistingLocal(String id, Object value) {
        for (Map<String, Object> scope : scopes) {
            if (scope.containsKey(id)) {
                scope.put(id, value);
                return true;
            }
        }
        return false;
    }

    private Object lookup(String id) {
        for (Map<String, Object> scope : scopes) {
            if (scope.containsKey(id)) return scope.get(id);
        }
        if (currentThis != null && currentThis.fields.containsKey(id)) return currentThis.fields.get(id);
        return globals.get(id);
    }

    private void assign(String id, Object value) {
        if (assignToExistingLocal(id, value)) return;
        if (currentThis != null && currentThis.fields.containsKey(id)) {
            currentThis.fields.put(id, value);
            return;
        }
        globals.put(id, value);
    }

    private int asInt(Object value) {
        return value == null ? 0 : ((Number) value).intValue();
    }

    private boolean isTruthy(Object value) {
        if (value == null) return false;
        if (value instanceof Number) return ((Number) value).intValue() != 0;
        if (value instanceof Boolean) return (Boolean) value;
        if (value instanceof String) return !((String) value).isEmpty();
        return true;
    }

    private List<Object> evalArgs(delphiParser.ArgListContext argList) {
        List<Object> values = new ArrayList<>();
        if (argList == null) return values;
        for (var e : argList.expr()) values.add(visit(e));
        return values;
    }

    private FoldResult foldExpr(delphiParser.ExprContext ctx) {
        if (ctx instanceof delphiParser.AddSubContext) {
            delphiParser.AddSubContext add = (delphiParser.AddSubContext) ctx;
            FoldResult l = foldExpr(add.expr(0));
            FoldResult r = foldExpr(add.expr(1));
            String op = add.op.getText();
            if (l.isIntConst && r.isIntConst) {
                int v = op.equals("+") ? (l.intValue + r.intValue) : (l.intValue - r.intValue);
                return new FoldResult(true, v, String.valueOf(v));
            }
            return new FoldResult(false, null, l.text + " " + op + " " + r.text);
        }
        if (ctx instanceof delphiParser.MulDivContext) {
            delphiParser.MulDivContext mul = (delphiParser.MulDivContext) ctx;
            FoldResult l = foldExpr(mul.expr(0));
            FoldResult r = foldExpr(mul.expr(1));
            String op = mul.op.getText();
            if (l.isIntConst && r.isIntConst) {
                int rv = (r.intValue == 0) ? 1 : r.intValue;
                int v = op.equals("*") ? (l.intValue * r.intValue) : (l.intValue / rv);
                return new FoldResult(true, v, String.valueOf(v));
            }
            return new FoldResult(false, null, l.text + " " + op + " " + r.text);
        }

        delphiParser.AtomContext atom = ((delphiParser.AtomExprContext) ctx).atom();
        if (atom.INT() != null) {
            int v = Integer.parseInt(atom.INT().getText());
            return new FoldResult(true, v, String.valueOf(v));
        }
        if (atom.STRING() != null) return new FoldResult(false, null, atom.STRING().getText());
        if (atom.expr() != null) {
            FoldResult inner = foldExpr(atom.expr());
            return new FoldResult(inner.isIntConst, inner.intValue, inner.text);
        }
        if (!atom.ID().isEmpty()) {
            // function call
            if (atom.getChildCount() >= 3 && "(".equals(atom.getChild(1).getText())) {
                String fn = atom.ID(0).getText();
                StringBuilder sb = new StringBuilder();
                sb.append(fn).append("(");
                if (atom.argList() != null) {
                    for (int i = 0; i < atom.argList().expr().size(); i++) {
                        if (i > 0) sb.append(", ");
                        sb.append(foldExpr(atom.argList().expr(i)).text);
                    }
                }
                sb.append(")");
                return new FoldResult(false, null, sb.toString());
            }
            // field access
            if (atom.ID().size() == 2) {
                return new FoldResult(false, null, atom.ID(0).getText() + "." + atom.ID(1).getText());
            }
            return new FoldResult(false, null, atom.ID(0).getText());
        }
        return new FoldResult(false, null, "<expr>");
    }

    private String foldedExprText(delphiParser.ExprContext ctx) {
        return foldExpr(ctx).text;
    }

    private void appendIndent(StringBuilder sb, int indent) {
        for (int i = 0; i < indent; i++) sb.append("  ");
    }

    private void appendStmtAst(StringBuilder sb, delphiParser.StmtContext s, int indent) {
        appendIndent(sb, indent);
        if (s.varDeclStmt() != null) {
            sb.append("var ").append(s.varDeclStmt().ID().getText()).append(": ")
              .append(s.varDeclStmt().type().getText()).append(";\n");
            return;
        }
        if (s.assignStmt() != null) {
            delphiParser.AssignStmtContext a = s.assignStmt();
            if (a.ID().size() == 2) sb.append(a.ID(0).getText()).append(".").append(a.ID(1).getText());
            else sb.append(a.ID(0).getText());
            sb.append(" := ").append(foldedExprText(a.expr())).append(";\n");
            return;
        }
        if (s.objStmt() != null) {
            delphiParser.ObjStmtContext o = s.objStmt();
            if (":=".equals(o.getChild(1).getText())) {
                sb.append(o.ID(0).getText()).append(" := ").append(o.ID(1).getText()).append(".Create(");
                if (o.argList() != null) {
                    for (int i = 0; i < o.argList().expr().size(); i++) {
                        if (i > 0) sb.append(", ");
                        sb.append(foldedExprText(o.argList().expr(i)));
                    }
                }
                sb.append(");\n");
            } else {
                sb.append(o.ID(0).getText()).append(".").append(o.ID(1).getText()).append("(");
                if (o.argList() != null) {
                    for (int i = 0; i < o.argList().expr().size(); i++) {
                        if (i > 0) sb.append(", ");
                        sb.append(foldedExprText(o.argList().expr(i)));
                    }
                }
                sb.append(");\n");
            }
            return;
        }
        if (s.procCallStmt() != null) {
            delphiParser.ProcCallStmtContext p = s.procCallStmt();
            sb.append(p.ID().getText()).append("(");
            if (p.argList() != null) {
                for (int i = 0; i < p.argList().expr().size(); i++) {
                    if (i > 0) sb.append(", ");
                    sb.append(foldedExprText(p.argList().expr(i)));
                }
            }
            sb.append(");\n");
            return;
        }
        if (s.ioStmt() != null) {
            if (s.ioStmt().getText().startsWith("readln")) {
                sb.append("readln(").append(s.ioStmt().ID().getText()).append(");\n");
            } else {
                sb.append("writeln(").append(foldedExprText(s.ioStmt().expr())).append(");\n");
            }
            return;
        }
        if (s.exprStmt() != null) {
            sb.append(foldedExprText(s.exprStmt().expr())).append(";\n");
            return;
        }
        if (s.breakStmt() != null) {
            sb.append("break;\n");
            return;
        }
        if (s.continueStmt() != null) {
            sb.append("continue;\n");
            return;
        }
        if (s.whileStmt() != null) {
            sb.append("while ").append(foldedExprText(s.whileStmt().expr())).append(" do\n");
            appendIndent(sb, indent);
            sb.append("begin\n");
            for (var inner : s.whileStmt().block().stmt()) appendStmtAst(sb, inner, indent + 1);
            appendIndent(sb, indent);
            sb.append("end\n");
            return;
        }
        if (s.forStmt() != null) {
            delphiParser.ForStmtContext f = s.forStmt();
            sb.append("for ").append(f.ID().getText()).append(" := ")
              .append(foldedExprText(f.expr(0))).append(" ")
              .append(f.getChild(4).getText()).append(" ")
              .append(foldedExprText(f.expr(1))).append(" do\n");
            appendIndent(sb, indent);
            sb.append("begin\n");
            for (var inner : f.block().stmt()) appendStmtAst(sb, inner, indent + 1);
            appendIndent(sb, indent);
            sb.append("end\n");
            return;
        }
        sb.append(";\n");
    }

    private void printFoldedAst(delphiParser.ProgramContext ctx) {
        StringBuilder sb = new StringBuilder();
        sb.append("=== Optimized AST (constant-folded expressions) ===\n");
        for (var s : ctx.stmt()) appendStmtAst(sb, s, 0);
        if (ctx.mainBlock() != null) {
            sb.append("begin\n");
            for (var s : ctx.mainBlock().stmt()) appendStmtAst(sb, s, 1);
            sb.append("end.\n");
        }
        sb.append("=== End Optimized AST ===");
        System.out.println(sb.toString());
    }

    private Object callRoutine(String name, delphiParser.ArgListContext argList, boolean mustReturn) {
        RoutineDef routine = routines.get(name);
        if (routine == null) throw new RuntimeException("Unknown routine: " + name);
        if (mustReturn && !routine.function) throw new RuntimeException("Routine is not a function: " + name);

        List<Object> args = evalArgs(argList);
        if (args.size() != routine.params.size()) {
            throw new RuntimeException("Argument count mismatch for " + name + ": expected " + routine.params.size() + ", got " + args.size());
        }

        Deque<Map<String, Object>> savedScopes = new ArrayDeque<>(scopes);
        Instance savedThis = currentThis;
        scopes.clear();
        currentThis = null;

        pushScope();
        if (routine.function) scopes.peek().put(name, 0);
        for (int i = 0; i < routine.params.size(); i++) {
            scopes.peek().put(routine.params.get(i), args.get(i));
        }

        try {
            visit(routine.block);
            if (routine.function) return lookup(name);
            return null;
        } finally {
            scopes.clear();
            scopes.addAll(savedScopes);
            currentThis = savedThis;
        }
    }

    @Override
    public Object visitProgram(delphiParser.ProgramContext ctx) {
        try {
            if (printOptimizedAst) printFoldedAst(ctx);
            for (var d : ctx.topLevelDecl()) visit(d);
            for (var s : ctx.stmt()) visit(s);
            if (ctx.mainBlock() != null) visitMainBlock(ctx.mainBlock());
        } catch (BreakSignal | ContinueSignal signal) {
            throw new RuntimeException("break/continue used outside loop");
        } finally {
            // Call destructors for all created objects
            for (Instance inst : allInstances) {
                if (inst.klass.destructor != null) {
                    Instance prevThis = currentThis;
                    currentThis = inst;
                    pushScope();
                    visit(inst.klass.destructor.block());
                    popScope();
                    currentThis = prevThis;
                }
            }
        }
        return null;
    }

    @Override
    public Object visitTopLevelDecl(delphiParser.TopLevelDeclContext ctx) {
        if (ctx.interfaceDecl() != null) return visitInterfaceDecl(ctx.interfaceDecl());
        if (ctx.classDecl() != null) return visitClassDecl(ctx.classDecl());
        if (ctx.procedureDecl() != null) return visitProcedureDecl(ctx.procedureDecl());
        if (ctx.functionDecl() != null) return visitFunctionDecl(ctx.functionDecl());
        return null;
    }

    @Override
    public Object visitProcedureDecl(delphiParser.ProcedureDeclContext ctx) {
        RoutineDef r = new RoutineDef();
        r.name = ctx.ID().getText();
        r.function = false;
        r.block = ctx.block();
        if (ctx.paramList() != null) {
            for (var p : ctx.paramList().param()) r.params.add(p.ID().getText());
        }
        routines.put(r.name, r);
        return null;
    }

    @Override
    public Object visitFunctionDecl(delphiParser.FunctionDeclContext ctx) {
        RoutineDef r = new RoutineDef();
        r.name = ctx.ID().getText();
        r.function = true;
        r.block = ctx.block();
        if (ctx.paramList() != null) {
            for (var p : ctx.paramList().param()) r.params.add(p.ID().getText());
        }
        routines.put(r.name, r);
        return null;
    }

    @Override
    public Object visitInterfaceDecl(delphiParser.InterfaceDeclContext ctx) {
        InterfaceDef iface = new InterfaceDef();
        iface.name = ctx.ID().getText();
        for (var sig : ctx.methodSignature()) {
            iface.requiredMethods.add(sig.ID().getText());
        }
        interfaces.put(iface.name, iface);
        return null;
    }

    @Override
    public Object visitMainBlock(delphiParser.MainBlockContext ctx) {
        for (var s : ctx.stmt()) visit(s);
        return null;
    }

    @Override
    public Object visitClassDecl(delphiParser.ClassDeclContext ctx) {
        ClassDef cd = new ClassDef();
        List<String> implementsNames = new ArrayList<>();

        // Delphi-like syntax: Name = class(Parent, IFace1, IFace2) begin ... end
        cd.name = ctx.ID(0).getText();
        if (ctx.ID().size() > 1) {
            for (int i = 1; i < ctx.ID().size(); i++) {
                String candidate = ctx.ID(i).getText();
                if (interfaces.containsKey(candidate)) implementsNames.add(candidate);
                else if (cd.superName == null) cd.superName = candidate;
                else implementsNames.add(candidate);
            }
        }
        
        // Inherit from parent class
        if (cd.superName != null) {
            ClassDef parent = classes.get(cd.superName);
            if (parent != null) {
                cd.fields.addAll(parent.fields);
                cd.methods.putAll(parent.methods);
                cd.fieldVisibility.putAll(parent.fieldVisibility);
                if (cd.constructor == null) cd.constructor = parent.constructor;
            }
        }
        
        for (var m : ctx.classMember()) {
            if (m.fieldDecl() != null) {
                cd.fields.add(m.fieldDecl());
                String fieldName = m.fieldDecl().ID().getText();
                boolean isPrivate = m.fieldDecl().getText().startsWith("private");
                cd.fieldVisibility.put(fieldName, isPrivate);
            }
            if (m.constructorDecl() != null) cd.constructor = m.constructorDecl();
            if (m.destructorDecl() != null) cd.destructor = m.destructorDecl();
            if (m.methodDecl() != null) cd.methods.put(m.methodDecl().ID().getText(), m.methodDecl());
        }
        
        // Check interface implementation
        for (String implementsName : implementsNames) {
            InterfaceDef iface = interfaces.get(implementsName);
            if (iface == null) {
                throw new RuntimeException("Interface " + implementsName + " not found");
            }
            for (String required : iface.requiredMethods) {
                if (!cd.methods.containsKey(required)) {
                    throw new RuntimeException("Class " + cd.name + " must implement method " + required + " from interface " + implementsName);
                }
            }
        }
        
        classes.put(cd.name, cd);
        return null;
    }

    @Override
    public Object visitVarDeclStmt(delphiParser.VarDeclStmtContext ctx) {
        String id = ctx.ID().getText();
        declareVariable(id, null);
        return null;
    }

    @Override
    public Object visitAssignStmt(delphiParser.AssignStmtContext ctx) {
        Object val = visit(ctx.expr());
        
        // Check if it's obj.field := value
        if (ctx.ID().size() == 2) {
            String objName = ctx.ID(0).getText();
            String fieldName = ctx.ID(1).getText();
            Object o = globals.get(objName);
            if (!(o instanceof Instance)) throw new RuntimeException("Not an object: " + objName);
            Instance inst = (Instance)o;
            
            // Check if field is private and we're accessing from outside
            Boolean isPrivate = inst.klass.fieldVisibility.get(fieldName);
            if (isPrivate != null && isPrivate && currentThis != inst) {
                throw new RuntimeException("Cannot assign to private field '" + fieldName + "' from outside class");
            }
            inst.fields.put(fieldName, val);
        } else {
            // Regular variable assignment
            String id = ctx.ID(0).getText();
            assign(id, val);
        }
        return null;
    }

    @Override
    public Object visitObjStmt(delphiParser.ObjStmtContext ctx) {
        if (":=".equals(ctx.getChild(1).getText())) {
            String var = ctx.ID(0).getText();
            // var := ClassName.Create(...)
            String cname = ctx.ID(1).getText();
            String ctorName = ctx.getChild(4).getText();
            if (!("Create".equals(ctorName) || "create".equals(ctorName))) {
                throw new RuntimeException("Only Class.Create(...) construction is supported");
            }
            ClassDef cd = classes.get(cname);
            if (cd == null) throw new RuntimeException("Unknown class: " + cname);
            Instance inst = new Instance(cd);
            for (var f : cd.fields) inst.fields.put(f.ID().getText(), null);
            if (cd.constructor != null) {
                Instance prevThis = currentThis;
                currentThis = inst;
                pushScope();
                // Bind constructor parameters
                List<Object> args = evalArgs(ctx.argList());
                int expected = (cd.constructor.paramList() == null) ? 0 : cd.constructor.paramList().param().size();
                if (expected != args.size()) {
                    throw new RuntimeException("Constructor argument count mismatch for " + cname + ": expected " + expected + ", got " + args.size());
                }
                if (cd.constructor.paramList() != null) {
                    var params = cd.constructor.paramList().param();
                    for (int i = 0; i < params.size(); i++) {
                        String paramName = params.get(i).ID().getText();
                        scopes.peek().put(paramName, args.get(i));
                    }
                }
                visit(cd.constructor.block());
                popScope();
                currentThis = prevThis;
            }
            allInstances.add(inst);
            globals.put(var, inst);
        } else {
            String objName = ctx.ID(0).getText();
            String method = ctx.ID(1).getText();
            Object o = globals.get(objName);
            if (!(o instanceof Instance)) throw new RuntimeException("Not an object: " + objName);
            Instance inst = (Instance)o;
            delphiParser.MethodDeclContext mctx = inst.klass.methods.get(method);
            if (mctx == null) throw new RuntimeException("Method not found: " + method + " in " + inst.klass.name);
            Instance prevThis = currentThis;
            currentThis = inst;
            pushScope();
            // Bind method parameters
            List<Object> args = evalArgs(ctx.argList());
            int expected = (mctx.paramList() == null) ? 0 : mctx.paramList().param().size();
            if (expected != args.size()) {
                throw new RuntimeException("Method argument count mismatch for " + method + ": expected " + expected + ", got " + args.size());
            }
            if (mctx.paramList() != null) {
                var params = mctx.paramList().param();
                for (int i = 0; i < params.size(); i++) {
                    String paramName = params.get(i).ID().getText();
                    scopes.peek().put(paramName, args.get(i));
                }
            }
            visit(mctx.block());
            popScope();
            currentThis = prevThis;
        }
        return null;
    }

    @Override
    public Object visitProcCallStmt(delphiParser.ProcCallStmtContext ctx) {
        callRoutine(ctx.ID().getText(), ctx.argList(), false);
        return null;
    }

    @Override
    public Object visitWhileStmt(delphiParser.WhileStmtContext ctx) {
        while (isTruthy(visit(ctx.expr()))) {
            boolean shouldBreak = false;
            pushScope();
            try {
                visit(ctx.block());
            } catch (ContinueSignal c) {
                // Continue loop.
            } catch (BreakSignal b) {
                shouldBreak = true;
            } finally {
                popScope();
            }
            if (shouldBreak) break;
        }
        return null;
    }

    @Override
    public Object visitForStmt(delphiParser.ForStmtContext ctx) {
        String id = ctx.ID().getText();
        int start = asInt(visit(ctx.expr(0)));
        int end = asInt(visit(ctx.expr(1)));
        boolean downTo = "downto".equals(ctx.getChild(4).getText());

        for (int i = start; downTo ? i >= end : i <= end; i += downTo ? -1 : 1) {
            boolean shouldBreak = false;
            pushScope();
            try {
                assign(id, i);
                visit(ctx.block());
            } catch (ContinueSignal c) {
                // Continue loop.
            } catch (BreakSignal b) {
                shouldBreak = true;
            } finally {
                popScope();
            }
            if (shouldBreak) break;
        }
        return null;
    }

    @Override
    public Object visitBreakStmt(delphiParser.BreakStmtContext ctx) {
        throw new BreakSignal();
    }

    @Override
    public Object visitContinueStmt(delphiParser.ContinueStmtContext ctx) {
        throw new ContinueSignal();
    }

    @Override
    public Object visitIoStmt(delphiParser.IoStmtContext ctx) {
        if (ctx.getText().startsWith("readln")) {
            String id = ctx.ID().getText();
            String line = null;
            if (scanner.hasNextLine()) line = scanner.nextLine();
            Integer v = 0;
            try { if (line != null) v = Integer.parseInt(line.trim()); } catch (Exception e) {}
            assign(id, v);
        } else {
            Object val = visit(ctx.expr());
            System.out.println(val == null ? "null" : val.toString());
        }
        return null;
    }

    @Override
    public Object visitExprStmt(delphiParser.ExprStmtContext ctx) {
        visit(ctx.expr());
        return null;
    }

    @Override
    public Object visitBlock(delphiParser.BlockContext ctx) {
        for (var s : ctx.stmt()) visit(s);
        return null;
    }

    @Override
    public Object visitAddSub(delphiParser.AddSubContext ctx) {
        Object l = visit(ctx.expr(0));
        Object r = visit(ctx.expr(1));
        String op = ctx.op.getText();
        if (l instanceof String || r instanceof String) return String.valueOf(l) + String.valueOf(r);
        int li = asInt(l);
        int ri = asInt(r);
        return op.equals("+") ? (li + ri) : (li - ri);
    }

    @Override
    public Object visitMulDiv(delphiParser.MulDivContext ctx) {
        Object l = visit(ctx.expr(0));
        Object r = visit(ctx.expr(1));
        String op = ctx.op.getText();
        int li = asInt(l);
        int ri = asInt(r);
        return op.equals("*") ? (li * ri) : (li / (ri==0?1:ri));
    }

    @Override
    public Object visitAtomExpr(delphiParser.AtomExprContext ctx) {
        return visit(ctx.atom());
    }

    @Override
    public Object visitAtom(delphiParser.AtomContext ctx) {
        if (ctx.INT() != null) return Integer.parseInt(ctx.INT().getText());
        if (ctx.STRING() != null) {
            String s = ctx.STRING().getText();
            return s.substring(1, s.length()-1).replaceAll("\\\\\"","\"");
        }
        if (!ctx.ID().isEmpty()) {
            if (ctx.getChildCount() >= 3 && "(".equals(ctx.getChild(1).getText())) {
                String fn = ctx.ID(0).getText();
                return callRoutine(fn, ctx.argList(), true);
            }
            if (ctx.ID().size() == 2) {
                String a = ctx.ID(0).getText();
                String b = ctx.ID(1).getText();
                Object o = globals.get(a);
                if (!(o instanceof Instance)) throw new RuntimeException("Not an object: " + a);
                Instance inst = (Instance)o;
                // Check if field is private and we're accessing from outside
                Boolean isPrivate = inst.klass.fieldVisibility.get(b);
                if (isPrivate != null && isPrivate && currentThis != inst) {
                    throw new RuntimeException("Cannot access private field '" + b + "' from outside class");
                }
                return inst.fields.get(b);
            }
            String id = ctx.ID(0).getText();
            return lookup(id);
        }
        if (ctx.expr() != null) return visit(ctx.expr());
        return null;
    }
}
