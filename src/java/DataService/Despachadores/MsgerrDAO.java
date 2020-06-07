package DataService.Despachadores;

import BusinessServices.Beans.BeanMsgerr;
import javax.servlet.http.HttpServletRequest;

public interface MsgerrDAO {

    public BeanMsgerr getMsgerr(BeanMsgerr objBnMsgerr);

    public Integer iduMsgerr(BeanMsgerr objMsgerr);

    public Integer iduLog(String usuario, String tipo, String mensaje, HttpServletRequest request);

}
