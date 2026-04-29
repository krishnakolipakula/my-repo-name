import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import java.io.*;

public class Main {
    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.out.println("Usage: java -jar delphi.jar <inputfile>");
            System.out.println("Or: mvn exec:java -Dexec.args=\"tests/test1.pas\"");
            return;
        }
        String inputFile = args[0];
        CharStream input = CharStreams.fromFileName(inputFile);
        delphiLexer lexer = new delphiLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        delphiParser parser = new delphiParser(tokens);
        delphiParser.ProgramContext tree = parser.program();
        Interpreter interpreter = new Interpreter();
        interpreter.visit(tree);
    }
}
