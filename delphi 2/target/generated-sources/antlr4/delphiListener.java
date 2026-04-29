// Generated from java-escape by ANTLR 4.11.1
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link delphiParser}.
 */
public interface delphiListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link delphiParser#program}.
	 * @param ctx the parse tree
	 */
	void enterProgram(delphiParser.ProgramContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#program}.
	 * @param ctx the parse tree
	 */
	void exitProgram(delphiParser.ProgramContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#classDecl}.
	 * @param ctx the parse tree
	 */
	void enterClassDecl(delphiParser.ClassDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#classDecl}.
	 * @param ctx the parse tree
	 */
	void exitClassDecl(delphiParser.ClassDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#interfaceDecl}.
	 * @param ctx the parse tree
	 */
	void enterInterfaceDecl(delphiParser.InterfaceDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#interfaceDecl}.
	 * @param ctx the parse tree
	 */
	void exitInterfaceDecl(delphiParser.InterfaceDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#classMember}.
	 * @param ctx the parse tree
	 */
	void enterClassMember(delphiParser.ClassMemberContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#classMember}.
	 * @param ctx the parse tree
	 */
	void exitClassMember(delphiParser.ClassMemberContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#interfaceMember}.
	 * @param ctx the parse tree
	 */
	void enterInterfaceMember(delphiParser.InterfaceMemberContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#interfaceMember}.
	 * @param ctx the parse tree
	 */
	void exitInterfaceMember(delphiParser.InterfaceMemberContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#fieldDecl}.
	 * @param ctx the parse tree
	 */
	void enterFieldDecl(delphiParser.FieldDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#fieldDecl}.
	 * @param ctx the parse tree
	 */
	void exitFieldDecl(delphiParser.FieldDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#methodDecl}.
	 * @param ctx the parse tree
	 */
	void enterMethodDecl(delphiParser.MethodDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#methodDecl}.
	 * @param ctx the parse tree
	 */
	void exitMethodDecl(delphiParser.MethodDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#constructorDecl}.
	 * @param ctx the parse tree
	 */
	void enterConstructorDecl(delphiParser.ConstructorDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#constructorDecl}.
	 * @param ctx the parse tree
	 */
	void exitConstructorDecl(delphiParser.ConstructorDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#destructorDecl}.
	 * @param ctx the parse tree
	 */
	void enterDestructorDecl(delphiParser.DestructorDeclContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#destructorDecl}.
	 * @param ctx the parse tree
	 */
	void exitDestructorDecl(delphiParser.DestructorDeclContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#methodSignature}.
	 * @param ctx the parse tree
	 */
	void enterMethodSignature(delphiParser.MethodSignatureContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#methodSignature}.
	 * @param ctx the parse tree
	 */
	void exitMethodSignature(delphiParser.MethodSignatureContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#paramList}.
	 * @param ctx the parse tree
	 */
	void enterParamList(delphiParser.ParamListContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#paramList}.
	 * @param ctx the parse tree
	 */
	void exitParamList(delphiParser.ParamListContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#param}.
	 * @param ctx the parse tree
	 */
	void enterParam(delphiParser.ParamContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#param}.
	 * @param ctx the parse tree
	 */
	void exitParam(delphiParser.ParamContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#type}.
	 * @param ctx the parse tree
	 */
	void enterType(delphiParser.TypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#type}.
	 * @param ctx the parse tree
	 */
	void exitType(delphiParser.TypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmt(delphiParser.StmtContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmt(delphiParser.StmtContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#varDeclStmt}.
	 * @param ctx the parse tree
	 */
	void enterVarDeclStmt(delphiParser.VarDeclStmtContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#varDeclStmt}.
	 * @param ctx the parse tree
	 */
	void exitVarDeclStmt(delphiParser.VarDeclStmtContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#assignStmt}.
	 * @param ctx the parse tree
	 */
	void enterAssignStmt(delphiParser.AssignStmtContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#assignStmt}.
	 * @param ctx the parse tree
	 */
	void exitAssignStmt(delphiParser.AssignStmtContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#exprStmt}.
	 * @param ctx the parse tree
	 */
	void enterExprStmt(delphiParser.ExprStmtContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#exprStmt}.
	 * @param ctx the parse tree
	 */
	void exitExprStmt(delphiParser.ExprStmtContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#objStmt}.
	 * @param ctx the parse tree
	 */
	void enterObjStmt(delphiParser.ObjStmtContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#objStmt}.
	 * @param ctx the parse tree
	 */
	void exitObjStmt(delphiParser.ObjStmtContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#ioStmt}.
	 * @param ctx the parse tree
	 */
	void enterIoStmt(delphiParser.IoStmtContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#ioStmt}.
	 * @param ctx the parse tree
	 */
	void exitIoStmt(delphiParser.IoStmtContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#block}.
	 * @param ctx the parse tree
	 */
	void enterBlock(delphiParser.BlockContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#block}.
	 * @param ctx the parse tree
	 */
	void exitBlock(delphiParser.BlockContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#argList}.
	 * @param ctx the parse tree
	 */
	void enterArgList(delphiParser.ArgListContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#argList}.
	 * @param ctx the parse tree
	 */
	void exitArgList(delphiParser.ArgListContext ctx);
	/**
	 * Enter a parse tree produced by the {@code MulDiv}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterMulDiv(delphiParser.MulDivContext ctx);
	/**
	 * Exit a parse tree produced by the {@code MulDiv}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitMulDiv(delphiParser.MulDivContext ctx);
	/**
	 * Enter a parse tree produced by the {@code AddSub}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterAddSub(delphiParser.AddSubContext ctx);
	/**
	 * Exit a parse tree produced by the {@code AddSub}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitAddSub(delphiParser.AddSubContext ctx);
	/**
	 * Enter a parse tree produced by the {@code AtomExpr}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterAtomExpr(delphiParser.AtomExprContext ctx);
	/**
	 * Exit a parse tree produced by the {@code AtomExpr}
	 * labeled alternative in {@link delphiParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitAtomExpr(delphiParser.AtomExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link delphiParser#atom}.
	 * @param ctx the parse tree
	 */
	void enterAtom(delphiParser.AtomContext ctx);
	/**
	 * Exit a parse tree produced by {@link delphiParser#atom}.
	 * @param ctx the parse tree
	 */
	void exitAtom(delphiParser.AtomContext ctx);
}