package ifrs.edu.br;

import ifrs.edu.br.negocio.Cliente;
import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public interface OperacoesCrud {
    ResultObjectTuple cadastrar(PooledConnection connection) throws SQLException;
    void editar(PooledConnection connection) throws SQLException;

    default void deletar(PooledConnection connection) throws SQLException{
        Connection pgConnection = connection.getConnection();
        ResultSet rs = procuraRegistro(pgConnection);
        rs = selecionaRow(rs, this);
        rs.deleteRow();
        pgConnection.commit();
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
