package ifrs.edu.br;

import org.postgresql.ds.PGConnectionPoolDataSource;

import javax.sql.PooledConnection;
import java.sql.ResultSet;

public interface OperacoesCrud {
    void cadastrar(PooledConnection connection);
    void editar(PooledConnection connection);
    void deletar(PooledConnection connection);
    ResultSet procuraRegistro(PooledConnection connection);
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
