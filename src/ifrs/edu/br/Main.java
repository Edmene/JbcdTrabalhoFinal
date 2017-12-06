package ifrs.edu.br;

import ifrs.edu.br.negocio.Cliente;
import ifrs.edu.br.negocio.Produto;
import ifrs.edu.br.venda.Venda;
import org.postgresql.ds.PGConnectionPoolDataSource;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Formatter;
import java.util.Scanner;

public class Main {

    private static String usuario = new String();
    private static String senha = new String();
    private static String nomeDb = new String();
    private static String servidor = new String();
    private static String porta = new String();

    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        try{
            PGConnectionPoolDataSource dataSource = new PGConnectionPoolDataSource();
            dataSource.setDefaultAutoCommit(false);
            ResultSet rs = null;
            Path path = Paths.get("server.conf");
            Boolean existe = path.toFile().createNewFile();

            if(!existe) {
                File file = path.toFile();
                Scanner scFile = new Scanner(file).useDelimiter(";");
                while (scFile.hasNext()) {
                    String tmp = scFile.next();
                    tmp = tmp.replace(";", "").trim();
                    if (tmp.contains("user=")) {
                        usuario = tmp;
                        replaceUser();
                    }
                    if (tmp.contains("password=")) {
                        senha = tmp;
                        replacePassword();
                    }
                    if (tmp.contains("db=")) {
                        nomeDb = tmp;
                        replaceDb();
                    }
                    if (tmp.contains("server=")) {
                        servidor = tmp;
                        replaceServer();
                    }
                    if (tmp.contains("port=")) {
                        porta = tmp;
                        replacePort();
                    }
                }
                try {
                    Integer.valueOf(porta);
                }
                catch (NumberFormatException e){
                    falhaDeLeitura(path, sc);
                }
            }
            else {
                falhaDeLeitura(path, sc);
            }

            dataSource.setUser(usuario);
            dataSource.setPassword(senha);
            dataSource.setDatabaseName(nomeDb);
            dataSource.setServerName(servidor);
            dataSource.setPortNumber(Integer.valueOf(porta));


            boolean continuar = true;
            while(continuar){
                mostrarMenu();
                int opInicial = leInt(sc);
                if(opInicial == -1){
                    continuar = false;
                }
                else{
                    if(opInicial == 0){
                        System.out.println("\nCliente");
                        mostrarMenuTipo2();
                    }
                    if(opInicial == 1){
                        System.out.println("\nProduto");
                        mostrarMenuTipo2();
                    }
                    if(opInicial == 2){
                        System.out.println("\nVenda");
                        mostrarMenuTipo2();
                    }
                    int op2 = leInt(sc);
                    subMenus(opInicial, op2, dataSource);
                }
            }
        }
        catch (Exception e){
            System.out.println(e);
        }
    }

    private static void replaceUser(){
        usuario = usuario.replace("user=", "");
    }

    private static void replacePassword(){
        senha = senha.replace("password=", "");
    }

    private static void replaceDb(){
        nomeDb = nomeDb.replace("db=", "");
    }

    private static void replaceServer(){
        servidor = servidor.replace("server=", "");
    }

    private static void replacePort(){
        porta = porta.replace("port=", "");
    }

    private static void falhaDeLeitura(Path path, Scanner sc) throws IOException{
        Scanner scanner = new Scanner(System.in);
        System.out.println("Por favor digite as configuracoes do servidor");
        System.out.print("Usuario: ");
        usuario = "user="+scanner.nextLine();
        System.out.print("Senha: ");
        senha = "password="+scanner.nextLine();
        System.out.print("Nome do DB: ");
        nomeDb = "db="+scanner.nextLine();
        System.out.print("Servidor: ");
        servidor = "server="+scanner.nextLine();
        System.out.print("Porta: ");
        porta = "port="+scanner.nextLine();

        Formatter ft = new Formatter(new BufferedWriter(new FileWriter(path.toFile(),false)));
        ft.format("%s;\n%s;\n%s;\n%s;\n%s;", usuario, senha, nomeDb, servidor, porta);
        ft.close();

        replaceUser();
        replacePassword();
        replaceDb();
        replaceServer();
        replacePort();
    }

    private static void subMenus(int op, int op2, PGConnectionPoolDataSource dataSource) throws SQLException{
        OperacoesCrud opSql = new Cliente();

        if(op != -1){
            if (op == 0) {
                opSql = new Cliente();
            }
            if (op == 1) {
                opSql = new Produto();
            }
            if(op == 2){
                opSql = new Venda();
            }

            if(op2 == 0) {
                opSql.cadastrar(dataSource);
            }
            if (op2 == 1) {
                opSql.editar(dataSource);
            }
            if (op2 == 2) {
                opSql.deletar(dataSource);
            }
            if (op2 == 3){
                opSql.listar(dataSource);
            }
        }
    }


    private static int leInt(Scanner sc){
        int inteiro = sc.nextInt();
        sc.nextLine();
        return inteiro;
    }

    private static void iteraEntreStrings(String[] iterar){
        for(int i=0;i<iterar.length;i++){
            System.out.println(i+")"+iterar[i]);
        }
        System.out.println("-1)Sair");
        System.out.print("Digite uma opcao:");
    }

    private static void mostrarMenu(){
        System.out.println();
        String[] entradas = {"Cliente","Produto","Venda"};
        iteraEntreStrings(entradas);
    }

    private static void mostrarMenuTipo2(){
        String[] entradas = {"Cadastrar","Editar","Deletar","Listar"};
        iteraEntreStrings(entradas);
    }

}

