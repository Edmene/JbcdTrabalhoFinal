package ifrs.edu.br;

import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public interface OperacoesCrud {
    void cadastrar(PooledConnection connection);
    void editar(PooledConnection connection) throws SQLException;
    void deletar(PooledConnection connection);
    ResultSet procuraRegistro(Connection connection) throws SQLException;
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
}
