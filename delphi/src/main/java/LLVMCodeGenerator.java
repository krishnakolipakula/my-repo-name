import java.util.*;
import java.io.*;

/**
 * LLVM IR Code Generator for Delphi/Pascal
 * Generates complete LLVM Intermediate Representation from parse tree
 */
public class LLVMCodeGenerator extends delphiBaseVisitor<String> {
    
    private final PrintWriter out;
    private int labelId = 0;
    private int varId = 0;
    private int stringId = 0;
    private final Deque<Map<String, String>> scopes = new ArrayDeque<>();
    private final StringBuilder globalStrings = new StringBuilder();
    private boolean inFunction = false;
    
    public LLVMCodeGenerator(PrintWriter writer) {
        this.out = writer;
        scopes.push(new HashMap<>());
    }
    
    private String label(String prefix) {
        return prefix + "_" + labelId++;
    }
    
    private String var_() {
        return "%v" + varId++;
    }
    
    private String stringConst() {
        return "@str" + stringId++;
    }
    
    private void emit(String code) {
        out.println(code);
    }
    
    private String lookup(String name) {
        for (var scope : scopes) {
            if (scope.containsKey(name)) return scope.get(name);
        }
        return null;
    }
    
    private void define(String name, String llvmReg) {
        scopes.peek().put(name, llvmReg);
    }
    
    public void generate(delphiParser.ProgramContext ctx) {
        emit("; LLVM IR for Delphi/Pascal");
        emit("; Generated: " + new java.util.Date());
        emit("");
        
        // External declarations
        emit("declare i32 @printf(i8*, ...)");
        emit("declare i32 @scanf(i8*, ...)");
        emit("");
        
        // Process procedures and functions
        for (var decl : ctx.topLevelDecl()) {
            if (decl.procedureDecl() != null) {
                processProcedure(decl.procedureDecl());
            } else if (decl.functionDecl() != null) {
                processFunction(decl.functionDecl());
            }
        }
        
        // Main
        emit("define i32 @main() {");
        scopes.push(new HashMap<>());
        
        for (var stmt : ctx.stmt()) {
            processStmt(stmt);
        }
        
        if (ctx.mainBlock() != null) {
            for (var stmt : ctx.mainBlock().stmt()) {
                processStmt(stmt);
            }
        }
        
        emit("  ret i32 0");
        scopes.pop();
        emit("}");
        emit("");
        
        // Output global strings at end
        out.print(globalStrings.toString());
    }
    
    private void processProcedure(delphiParser.ProcedureDeclContext ctx) {
        String name = ctx.ID().getText();
        int numParams = ctx.paramList() != null ? ctx.paramList().param().size() : 0;
        
        StringBuilder sig = new StringBuilder("define void @").append(name).append("(");
        for (int i = 0; i < numParams; i++) {
            if (i > 0) sig.append(", ");
            sig.append("i32 %p").append(i);
        }
        sig.append(") {");
        
        emit(sig.toString());
        scopes.push(new HashMap<>());
        inFunction = true;
        
        // Bind parameters
        if (ctx.paramList() != null) {
            for (int i = 0; i < ctx.paramList().param().size(); i++) {
                String pname = ctx.paramList().param(i).ID().getText();
                define(pname, "%p" + i);
            }
        }
        
        // Process body
        if (ctx.block() != null) {
            for (var stmt : ctx.block().stmt()) {
                processStmt(stmt);
            }
        }
        
        emit("  ret void");
        scopes.pop();
        inFunction = false;
        emit("}");
        emit("");
    }
    
    private void processFunction(delphiParser.FunctionDeclContext ctx) {
        String name = ctx.ID().getText();
        int numParams = ctx.paramList() != null ? ctx.paramList().param().size() : 0;
        
        StringBuilder sig = new StringBuilder("define i32 @").append(name).append("(");
        for (int i = 0; i < numParams; i++) {
            if (i > 0) sig.append(", ");
            sig.append("i32 %p").append(i);
        }
        sig.append(") {");
        
        emit(sig.toString());
        scopes.push(new HashMap<>());
        inFunction = true;
        
        // Bind parameters
        if (ctx.paramList() != null) {
            for (int i = 0; i < ctx.paramList().param().size(); i++) {
                String pname = ctx.paramList().param(i).ID().getText();
                define(pname, "%p" + i);
            }
        }
        
        // Process body
        if (ctx.block() != null) {
            for (var stmt : ctx.block().stmt()) {
                processStmt(stmt);
            }
        }
        
        emit("  ret i32 0");
        scopes.pop();
        inFunction = false;
        emit("}");
        emit("");
    }
    
    private void processStmt(delphiParser.StmtContext ctx) {
        if (ctx.varDeclStmt() != null) {
            processVarDecl(ctx.varDeclStmt());
        } else if (ctx.assignStmt() != null) {
            processAssign(ctx.assignStmt());
        } else if (ctx.whileStmt() != null) {
            processWhile(ctx.whileStmt());
        } else if (ctx.forStmt() != null) {
            processFor(ctx.forStmt());
        } else if (ctx.ioStmt() != null) {
            processIO(ctx.ioStmt());
        } else if (ctx.procCallStmt() != null) {
            processProcCall(ctx.procCallStmt());
        }
    }
    
    private void processVarDecl(delphiParser.VarDeclStmtContext ctx) {
        String name = ctx.ID().getText();
        String llvmVar = var_();
        emit("  " + llvmVar + " = alloca i32");
        emit("  store i32 0, i32* " + llvmVar);
        define(name, llvmVar);
    }
    
    private void processAssign(delphiParser.AssignStmtContext ctx) {
        String name = ctx.ID(0).getText();
        String exprVal = processExpr(ctx.expr());
        
        String llvmVar = lookup(name);
        if (llvmVar == null) {
            llvmVar = var_();
            emit("  " + llvmVar + " = alloca i32");
            define(name, llvmVar);
        }
        
        emit("  store i32 " + exprVal + ", i32* " + llvmVar);
    }
    
    private void processWhile(delphiParser.WhileStmtContext ctx) {
        String startL = label("while_start");
        String bodyL = label("while_body");
        String endL = label("while_end");
        
        emit("  br label %" + startL);
        emit(startL + ":");
        
        String cond = processExpr(ctx.expr());
        emit("  br i1 " + cond + ", label %" + bodyL + ", label %" + endL);
        
        emit(bodyL + ":");
        if (ctx.block() != null) {
            for (var s : ctx.block().stmt()) {
                processStmt(s);
            }
        }
        emit("  br label %" + startL);
        
        emit(endL + ":");
    }
    
    private void processFor(delphiParser.ForStmtContext ctx) {
        String varName = ctx.ID().getText();
        String startVal = processExpr(ctx.expr(0));
        String endVal = processExpr(ctx.expr(1));
        boolean isDownto = ctx.getChild(4).getText().equals("downto");
        
        String counter = var_();
        emit("  " + counter + " = alloca i32");
        emit("  store i32 " + startVal + ", i32* " + counter);
        define(varName, counter);
        
        String testL = label("for_test");
        String bodyL = label("for_body");
        String endL = label("for_end");
        
        emit("  br label %" + testL);
        emit(testL + ":");
        
        String counterVal = var_();
        emit("  " + counterVal + " = load i32, i32* " + counter);
        
        String cond = var_();
        if (isDownto) {
            emit("  " + cond + " = icmp sge i32 " + counterVal + ", " + endVal);
        } else {
            emit("  " + cond + " = icmp sle i32 " + counterVal + ", " + endVal);
        }
        
        emit("  br i1 " + cond + ", label %" + bodyL + ", label %" + endL);
        
        emit(bodyL + ":");
        if (ctx.block() != null) {
            for (var s : ctx.block().stmt()) {
                processStmt(s);
            }
        }
        
        String nextVal = var_();
        String currVal = var_();
        emit("  " + currVal + " = load i32, i32* " + counter);
        if (isDownto) {
            emit("  " + nextVal + " = sub i32 " + currVal + ", 1");
        } else {
            emit("  " + nextVal + " = add i32 " + currVal + ", 1");
        }
        emit("  store i32 " + nextVal + ", i32* " + counter);
        emit("  br label %" + testL);
        
        emit(endL + ":");
    }
    
    private void processIO(delphiParser.IoStmtContext ctx) {
        if (ctx.getText().startsWith("writeln")) {
            String val = processExpr(ctx.expr());
            String strId = stringConst();
            globalStrings.append(strId).append(" = private constant [4 x i8] c\"%d\\0A\\00\"\n");
            emit("  call i32 (i8*, ...) @printf(i8* " + strId + ", i32 " + val + ")");
        } else if (ctx.getText().startsWith("readln")) {
            String varName = ctx.ID().getText();
            String llvmVar = lookup(varName);
            if (llvmVar == null) {
                llvmVar = var_();
                emit("  " + llvmVar + " = alloca i32");
                define(varName, llvmVar);
            }
            String strId = stringConst();
            globalStrings.append(strId).append(" = private constant [3 x i8] c\"%d\\00\"\n");
            emit("  call i32 (i8*, ...) @scanf(i8* " + strId + ", i32* " + llvmVar + ")");
        }
    }
    
    private void processProcCall(delphiParser.ProcCallStmtContext ctx) {
        String procName = ctx.ID().getText();
        StringBuilder call = new StringBuilder("  call void @").append(procName).append("(");
        
        if (ctx.argList() != null) {
            for (int i = 0; i < ctx.argList().expr().size(); i++) {
                if (i > 0) call.append(", ");
                String arg = processExpr(ctx.argList().expr(i));
                call.append("i32 ").append(arg);
            }
        }
        
        call.append(")");
        emit(call.toString());
    }
    
    private String processExpr(delphiParser.ExprContext ctx) {
        if (ctx instanceof delphiParser.MulDivContext) {
            delphiParser.MulDivContext mc = (delphiParser.MulDivContext) ctx;
            String l = processExpr(mc.expr(0));
            String op = mc.op.getText();
            String r = processExpr(mc.expr(1));
            String res = var_();
            
            if ("*".equals(op)) {
                emit("  " + res + " = mul i32 " + l + ", " + r);
            } else {
                emit("  " + res + " = sdiv i32 " + l + ", " + r);
            }
            return res;
        }
        
        if (ctx instanceof delphiParser.AddSubContext) {
            delphiParser.AddSubContext ac = (delphiParser.AddSubContext) ctx;
            String l = processExpr(ac.expr(0));
            String op = ac.op.getText();
            String r = processExpr(ac.expr(1));
            String res = var_();
            
            if ("+".equals(op)) {
                emit("  " + res + " = add i32 " + l + ", " + r);
            } else {
                emit("  " + res + " = sub i32 " + l + ", " + r);
            }
            return res;
        }
        
        if (ctx instanceof delphiParser.AtomExprContext) {
            delphiParser.AtomExprContext aec = (delphiParser.AtomExprContext) ctx;
            return processAtom(aec.atom());
        }
        
        throw new RuntimeException("Unknown expr: " + ctx.getClass().getName());
    }
    
    private String processAtom(delphiParser.AtomContext ctx) {
        if (ctx.INT() != null) {
            return ctx.INT().getText();
        }
        
        if (!ctx.ID().isEmpty()) {
            String name = ctx.ID(0).getText();
            String llvmVar = lookup(name);
            if (llvmVar == null) {
                throw new RuntimeException("Undefined: " + name);
            }
            
            String res = var_();
            emit("  " + res + " = load i32, i32* " + llvmVar);
            return res;
        }
        
        if (ctx.expr() != null) {
            return processExpr(ctx.expr());
        }
        
        throw new RuntimeException("Unknown atom");
    }
}
