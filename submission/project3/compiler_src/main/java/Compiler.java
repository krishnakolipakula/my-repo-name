import org.antlr.v4.runtime.*;
import java.io.*;

/**
 * Compiler: Delphi/Pascal to LLVM IR
 * Entry point for the compiler that generates LLVM Intermediate Representation
 */
public class Compiler {
    
    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Usage: java Compiler <input.pas> [output.ll]");
            System.exit(1);
        }
        
        String inputFile = args[0];
        String outputFile = args.length > 1 ? args[1] : "output.ll";
        
        try {
            // Read input file
            CharStream input = CharStreams.fromFileName(inputFile);
            
            // Lexing and Parsing
            delphiLexer lexer = new delphiLexer(input);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            delphiParser parser = new delphiParser(tokens);
            
            // Parse into AST
            delphiParser.ProgramContext program = parser.program();
            
            // Code generation
            FileWriter fileWriter = new FileWriter(outputFile);
            PrintWriter writer = new PrintWriter(fileWriter);
            
            LLVMCodeGenerator codegen = new LLVMCodeGenerator(writer);
            codegen.generate(program);
            writer.flush();
            writer.close();
            fileWriter.close();
            
            System.out.println("✓ Compilation successful!");
            System.out.println("  Input:  " + inputFile);
            System.out.println("  Output: " + outputFile);
            System.out.println("  Generated LLVM IR file ready for compilation.");
            
        } catch (IOException e) {
            System.err.println("Error reading file: " + e.getMessage());
            System.exit(1);
        } catch (Exception e) {
            System.err.println("Compilation error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
