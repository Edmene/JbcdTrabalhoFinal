package ifrs.edu.br;


import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public interface OperacoesCrud {
    ResultObjectTuple cadastrar(PGConnectionPoolDataSource dataSource) throws SQLException;
    void editar(PGConnectionPoolDataSource dataSource) throws SQLException;

    default void listar(PGConnectionPoolDataSource dataSource) throws SQLException{
        Connection pgConnection = conectar(dataSource).getConnection();
        Statement stm = pgConnection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,
                ResultSet.CONCUR_UPDATABLE);
        ResultSet rs = pesquisa(3,null,stm);
        if(rs == null){
            return;
        }
        int rowInicial = rs.getRow();
        rs.last();
        if(rowInicial == rs.getRow()){
            System.out.println("Nenhum registro encontrado");
        }
        else {
            rs.first();
            selecionaRow(rs, this);
            stm.close();
            pgConnection.close();
        }
    }

    default void deletar(PGConnectionPoolDataSource dataSource) throws SQLException{
        Connection pgConnection = conectar(dataSource).getConnection();
        ResultSet rs = procuraRegistro(pgConnection);
        rs = selecionaRow(rs, this);
        if(rs != null) {
            rs.deleteRow();
            pgConnection.commit();
        }
        rs.close();
        pgConnection.close();
    }

    ResultSet procuraRegistro(Connection connection) throws SQLException;
    ResultSet pesquisa(int tipo, String entrada, Statement stmt) throws SQLException;
    Integer construirMenu(ResultSet rs, Integer base) throws SQLException;

    default PooledConnection conectar(PGConnectionPoolDataSource dataSource){
        PooledConnection connection;
        try {
            connection = dataSource.getPooledConnection();
            return connection;
        }
        catch (Exception e){
            return null;
        }
    }

    default ResultSet selecionaRow(ResultSet rs, OperacoesCrud crud) throws SQLException{
        //ResultSet rs = procuraRegistro(pgConnection);
        int inicio = 0;
        boolean permanecerEmLaco = true;
        while (permanecerEmLaco){
            Scanner sc = new Scanner(System.in);
            crud.construirMenu(rs, inicio);
            String entrada = sc.nextLine();
            if(entrada.contains(".") ||
                    entrada.contains(",") ||
                    entrada.contains("q")){

                if (entrada.contains(",") && inicio-9 >= 0) {
                    inicio -= 10;
                }
                ResultSet rs2 = rs;
                rs2.last();
                if (entrada.contains(".") && inicio < rs2.getRow() - 1) {
                    inicio += 10;
                }
                if (entrada.contains("q")) {
                    rs = null;
                    permanecerEmLaco = false;
                }

            }
            else{
                try{
                    rs.absolute(Integer.parseInt(entrada));
                    permanecerEmLaco = false;
                }
                catch (NumberFormatException e){
                    System.err.println("Erro ao converter para inteiro.");
                }
            }
        }
        return rs;
    }
}
