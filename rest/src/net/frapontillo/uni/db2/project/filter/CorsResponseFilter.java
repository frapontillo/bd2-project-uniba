package net.frapontillo.uni.db2.project.filter;

import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.ext.Provider;

import com.sun.jersey.spi.container.ContainerRequest;
import com.sun.jersey.spi.container.ContainerResponse;
import com.sun.jersey.spi.container.ContainerResponseFilter;

@Provider
public class CorsResponseFilter implements ContainerResponseFilter {
	@Override
	public ContainerResponse filter(ContainerRequest req, ContainerResponse res) {
		ResponseBuilder resp = Response.fromResponse(res.getResponse());
		// Permetto di accedere da qualsiasi origine, con qualsiasi metodo
        resp.header("Access-Control-Allow-Origin", "*")
        	.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
 
        // Se sono stati richiesti degli header, li permetto
        String reqHead = req.getHeaderValue("Access-Control-Request-Headers");
        if (reqHead != null && !reqHead.equals(null)) {
            resp.header("Access-Control-Allow-Headers", reqHead);
        }

        res.setResponse(resp.build());
        return res;
	}
}
