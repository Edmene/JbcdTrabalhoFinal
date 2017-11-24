package ifrs.edu.br;

import ifrs.edu.br.negocio.Cliente;
import ifrs.edu.br.negocio.Produto;
import ifrs.edu.br.venda.Venda;
import org.postgresql.ds.PGConnectionPoolDataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Main {

    public static void main(String[] args){
        Scanner sc = new Scanner(System.in);
        try{
            PGConnectionPoolDataSource dataSource = new PGConnectionPoolDataSource();
            dataSource.setDefaultAutoCommit(false);
            ResultSet rs = null;
            dataSource.setDatabaseName("jdbc_work");
            dataSource.setServerName("192.168.1.3");
            dataSource.setPassword("JdbcWorkIfrs2017");
            dataSource.setPortNumber(5432);
            dataSource.setUser("ifrs2017ads");

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

    private static void subMenus(int op, int op2, PGConnectionPoolDataSource dataSource) throws SQLException{
        OperacoesCrud opSql = new Cliente();

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
            opSql.cadastrar(opSql.conectar(dataSource));
        }
        if (op2 == 1) {
            opSql.editar(opSql.conectar(dataSource));
        }
        if (op2 == 2) {
            opSql.deletar(opSql.conectar(dataSource));
        }
        /////
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
        System.out.print("Digite uma opcao:");
    }

    private static void mostrarMenu(){
        System.out.println();
        String[] entradas = {"Cliente","Produto","Venda"};
        iteraEntreStrings(entradas);
    }

    private static void mostrarMenuTipo2(){
        String[] entradas = {"Cadastrar","Editar","Deletar"};
        iteraEntreStrings(entradas);
    }

}

