package ifrs.edu.br;

import java.sql.ResultSet;

public class ResultObjectTuple {
    ResultSet resultSet;
    Object object;

    public ResultObjectTuple(){
    }

    public ResultObjectTuple(ResultSet rs, Object obj){
        this.object = obj;
        this.resultSet = rs;
    }

    public void setObject(Object object) {
        this.object = object;
    }

    public void setResultSet(ResultSet resultSet) {
        this.resultSet = resultSet;
    }

    public Object getObject() {
        return object;
    }

    public ResultSet getResultSet() {
        return resultSet;
    }
}
