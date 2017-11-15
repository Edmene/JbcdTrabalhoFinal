package ifrs.edu.br;

import ifrs.edu.br.negocio.Administrador;
import ifrs.edu.br.negocio.Cliente;
import ifrs.edu.br.negocio.Produto;

import java.util.Scanner;

public class Main {

    public static void main(String[] args){
        //Adicionar login
        Scanner sc = new Scanner(System.in);
        try{
            boolean continuar = true;
            while(continuar){
                mostrarMenu();
                int opInicial = leInt(sc);
                if(opInicial == -1){
                    continuar = false;
                }
                else{
                    if(opInicial == 0){
                        mostrarMenuTipo2();
                    }
                    if(opInicial == 1){
                        mostrarMenuTipo2();
                    }
                    if(opInicial == 2){
                        mostrarMenuTipo2();
                    }
                    if(opInicial == 3){
                        mostrarMenuVenda();
                    }
                    int op2 = leInt(sc);
                    subMenus(opInicial, op2, sc);
                }
            }
        }
        catch (Exception e){
            System.out.println(e);
        }


        /*
        static final String JDBC_DRIVER = "org.postgresql.Driver";
        static final String DB_URL = "jdbc:postgresql://192.168.1.3/jdbc_work";
        static final String USER = "postgres";
        static final String PASS = "CreaAuzen64";

        Connection conn;
        Statement st;
        ResultSet rs;

        try {
            Class.forName(JDBC_DRIVER);
            System.out.println("Connecting to database...");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            st = conn.createStatement();
            rs = st.executeQuery("SELECT nome FROM motorista");

        }
        catch (Exception e){
            System.out.println(e);
        }
        */

    }

    private static void subMenus(int op, int op2, Scanner sc){
        if(op >= 0 && op < 3){
            if(op2 == 0){
                OperacoesCrud opSql = new Administrador();
                if (op == 0) {
                    Administrador adm = new Administrador();
                    opSql = adm;
                }
                if (op == 1) {
                    Cliente cli = new Cliente();
                    opSql = cli;
                }
                if (op == 2) {
                    Produto prod = new Produto();
                    opSql = prod;
                }
                opSql.cadastrar();
            }
            else {
                String nome = nomeRegistro(sc);
                OperacoesCrud opSql = new Administrador();
                if (op == 0) {
                    Administrador adm = new Administrador(nome);
                    opSql = adm;
                }
                if (op == 1) {
                    Cliente cli = new Cliente(nome);
                    opSql = cli;
                }
                if (op == 2) {
                    Produto prod = new Produto(nome, "", 0.0f);
                    opSql = prod;
                }
                if (op2 == 1) {
                    opSql.editar();
                }
                if (op2 == 2) {
                    opSql.deletar();
                }
            }
        }
        if(op == 3){
            if(op2 == 0){

            }
            if(op2 == 0){

            }
        }
    }

    private static int leInt(Scanner sc){
        int inteiro = sc.nextInt();
        sc.nextLine();
        return inteiro;
    }

    private static String nomeRegistro(Scanner sc){
        System.out.print("Digite o parametro de pesquisa do registro: ");
        return sc.nextLine();
    }

    private static void iteraEntreStrings(String[] iterar){
        for(int i=0;i<iterar.length;i++){
            System.out.println(i+")"+iterar[i]);
        }
        System.out.println("Digite uma opcao:");
    }

    private static void mostrarMenu(){
        String[] entradas = {"Vendedor","Cliente","Produto","Venda"};
        iteraEntreStrings(entradas);
    }

    private static void mostrarMenuTipo2(){
        String[] entradas = {"Cadastrar","Editar","Deletar"};
        iteraEntreStrings(entradas);
    }

    private static void mostrarMenuVenda(){
        String[] entradas = {"Iniciar","Pesquisar"};
        iteraEntreStrings(entradas);
    }
}

