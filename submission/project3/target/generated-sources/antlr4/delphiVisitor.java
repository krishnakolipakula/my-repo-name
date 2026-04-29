// Generated from java-escape by ANTLR 4.11.1
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link delphiParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface delphiVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link delphiParser#program}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProgram(delphiParser.ProgramContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#topLevelDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTopLevelDecl(delphiParser.TopLevelDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#mainBlock}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMainBlock(delphiParser.MainBlockContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#classDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClassDecl(delphiParser.ClassDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#interfaceDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInterfaceDecl(delphiParser.InterfaceDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#classMember}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClassMember(delphiParser.ClassMemberContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#methodSignature}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMethodSignature(delphiParser.MethodSignatureContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#fieldDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFieldDecl(delphiParser.FieldDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#methodDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMethodDecl(delphiParser.MethodDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#constructorDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConstructorDecl(delphiParser.ConstructorDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#destructorDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDestructorDecl(delphiParser.DestructorDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#procedureDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProcedureDecl(delphiParser.ProcedureDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#functionDecl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunctionDecl(delphiParser.FunctionDeclContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#paramList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParamList(delphiParser.ParamListContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#param}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParam(delphiParser.ParamContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType(delphiParser.TypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#stmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStmt(delphiParser.StmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#varDeclStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVarDeclStmt(delphiParser.VarDeclStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#assignStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAssignStmt(delphiParser.AssignStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#exprStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExprStmt(delphiParser.ExprStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#objStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitObjStmt(delphiParser.ObjStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#procCallStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProcCallStmt(delphiParser.ProcCallStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#whileStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWhileStmt(delphiParser.WhileStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#forStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitForStmt(delphiParser.ForStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#breakStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBreakStmt(delphiParser.BreakStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#continueStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitContinueStmt(delphiParser.ContinueStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#ioStmt}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIoStmt(delphiParser.IoStmtContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#block}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitBlock(delphiParser.BlockContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#argList}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArgList(delphiParser.ArgListContext ctx);
	/**
	 * Visit a parse tree produced by the {@code MulDiv}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMulDiv(delphiParser.MulDivContext ctx);
	/**
	 * Visit a parse tree produced by the {@code AddSub}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAddSub(delphiParser.AddSubContext ctx);
	/**
	 * Visit a parse tree produced by the {@code Comparison}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitComparison(delphiParser.ComparisonContext ctx);
	/**
	 * Visit a parse tree produced by the {@code AtomExpr}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAtomExpr(delphiParser.AtomExprContext ctx);
	/**
	 * Visit a parse tree produced by {@link delphiParser#atom}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAtom(delphiParser.AtomContext ctx);
}