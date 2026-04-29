import java.util.*;
import org.antlr.v4.runtime.tree.TerminalNode;

public class Interpreter extends delphiBaseVisitor<Object> {

    static class ClassDef {
        String name;
        String superName;
        List<delphiParser.FieldDeclContext> fields = new ArrayList<>();
        delphiParser.ConstructorDeclContext constructor;
        delphiParser.DestructorDeclContext destructor;
        Map<String, delphiParser.MethodDeclContext> methods = new HashMap<>();
    }

    static class Instance {
        ClassDef klass;
        Map<String, Object> fields = new HashMap<>();
        Instance(ClassDef k) { klass = k; }
    }

    private final Map<String, ClassDef> classes = new HashMap<>();
    private final Map<String, Object> globals = new HashMap<>();
    private final List<Instance> allInstances = new ArrayList<>();
    private final Deque<Map<String,Object>> locals = new ArrayDeque<>();
    private Instance currentThis = null;
    private final Scanner scanner = new Scanner(System.in);

    @Override
    public Object visitProgram(delphiParser.ProgramContext ctx) {
        try {
            for (var c : ctx.children) {
                if (c instanceof delphiParser.ClassDeclContext) visitClassDecl((delphiParser.ClassDeclContext)c);
                else if (c instanceof delphiParser.InterfaceDeclContext) {
                } else if (c instanceof delphiParser.StmtContext) visit(c);
            }
        } finally {
            // Call destructors for all created objects
            for (Instance inst : allInstances) {
                if (inst.klass.destructor != null) {
                    Instance prevThis = currentThis;
                    currentThis = inst;
                    locals.push(new HashMap<>());
                    visit(inst.klass.destructor.block());
                    locals.pop();
                    currentThis = prevThis;
                }
            }
        }
        return null;
    }

    @Override
    public Object visitClassDecl(delphiParser.ClassDeclContext ctx) {
        ClassDef cd = new ClassDef();
        cd.name = ctx.ID(0).getText();
        if (ctx.ID().size() > 1) cd.superName = ctx.ID(1).getText();
        
        // Inherit from parent class
        if (cd.superName != null) {
            ClassDef parent = classes.get(cd.superName);
            if (parent != null) {
                cd.fields.addAll(parent.fields);
                cd.methods.putAll(parent.methods);
                if (cd.constructor == null) cd.constructor = parent.constructor;
            }
        }
        
        for (var m : ctx.classMember()) {
            if (m.fieldDecl() != null) cd.fields.add(m.fieldDecl());
            if (m.constructorDecl() != null) cd.constructor = m.constructorDecl();
            if (m.destructorDecl() != null) cd.destructor = m.destructorDecl();
            if (m.methodDecl() != null) cd.methods.put(m.methodDecl().ID().getText(), m.methodDecl());
        }
        classes.put(cd.name, cd);
        return null;
    }

    @Override
    public Object visitVarDeclStmt(delphiParser.VarDeclStmtContext ctx) {
        String id = ctx.ID().getText();
        globals.put(id, null);
        return null;
    }

    @Override
    public Object visitAssignStmt(delphiParser.AssignStmtContext ctx) {
        String id = ctx.ID().getText();
        Object val = visit(ctx.expr());
        if (!locals.isEmpty() && locals.peek().containsKey(id)) {
            locals.peek().put(id, val);
        } else if (currentThis != null && currentThis.fields.containsKey(id)) {
            currentThis.fields.put(id, val);
        } else {
            globals.put(id, val);
        }
        return null;
    }

    @Override
    public Object visitObjStmt(delphiParser.ObjStmtContext ctx) {
        if (ctx.getText().contains("new")) {
            String var = ctx.ID(0).getText();
            String cname = ctx.ID(1).getText();
            ClassDef cd = classes.get(cname);
            if (cd == null) throw new RuntimeException("Unknown class: " + cname);
            Instance inst = new Instance(cd);
            for (var f : cd.fields) inst.fields.put(f.ID().getText(), null);
            if (cd.constructor != null) {
                Instance prevThis = currentThis;
                currentThis = inst;
                locals.push(new HashMap<>());
                visit(cd.constructor.block());
                locals.pop();
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
            locals.push(new HashMap<>());
            visit(mctx.block());
            locals.pop();
            currentThis = prevThis;
        }
        return null;
    }

    @Override
    public Object visitIoStmt(delphiParser.IoStmtContext ctx) {
        if (ctx.getText().startsWith("readln")) {
            String id = ctx.ID().getText();
            String line = null;
            if (scanner.hasNextLine()) line = scanner.nextLine();
            Integer v = 0;
            try { v = Integer.parseInt(line.trim()); } catch (Exception e) {}
            if (!locals.isEmpty() && locals.peek().containsKey(id)) locals.peek().put(id, v);
            else if (currentThis != null && currentThis.fields.containsKey(id)) currentThis.fields.put(id, v);
            else globals.put(id, v);
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
        int li = (l == null) ? 0 : ((Number)l).intValue();
        int ri = (r == null) ? 0 : ((Number)r).intValue();
        return op.equals("+") ? (li + ri) : (li - ri);
    }

    @Override
    public Object visitMulDiv(delphiParser.MulDivContext ctx) {
        Object l = visit(ctx.expr(0));
        Object r = visit(ctx.expr(1));
        String op = ctx.op.getText();
        int li = (l == null) ? 0 : ((Number)l).intValue();
        int ri = (r == null) ? 0 : ((Number)r).intValue();
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
        if (ctx.ID() != null) {
            if (ctx.ID().size() == 2) {
                String a = ctx.ID(0).getText();
                String b = ctx.ID(1).getText();
                Object o = globals.get(a);
                if (!(o instanceof Instance)) throw new RuntimeException("Not an object: " + a);
                return ((Instance)o).fields.get(b);
            }
            String id = ctx.ID(0).getText();
            if (!locals.isEmpty() && locals.peek().containsKey(id)) return locals.peek().get(id);
            if (currentThis != null && currentThis.fields.containsKey(id)) return currentThis.fields.get(id);
            return globals.get(id);
        }
        if (ctx.expr() != null) return visit(ctx.expr());
        return null;
    }
}
