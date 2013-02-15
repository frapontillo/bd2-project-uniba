package net.frapontillo.uni.db2.project.filter;

import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.Provider;

import net.frapontillo.uni.db2.project.exception.NotFoundException;

import com.sun.jersey.spi.container.ContainerRequest;
import com.sun.jersey.spi.container.ContainerResponse;
import com.sun.jersey.spi.container.ContainerResponseFilter;

@Provider
public class NullResponseFilter implements ContainerResponseFilter {
	@Override
	public ContainerResponse filter(ContainerRequest req, ContainerResponse res) {
		// Se l'oggetto è nullo, se il metodo non è OPTIONS e se lo status code è 200
		if (res.getEntity() == null &&
				!req.getMethod().equals("OPTIONS") &&
				res.getStatus() != Status.INTERNAL_SERVER_ERROR.getStatusCode() &&
				res.getStatus() != Status.NO_CONTENT.getStatusCode() &&
				res.getStatus() != Status.UNAUTHORIZED.getStatusCode())
			throw new NotFoundException();
		
		// Forzo la restituzione dello status code 200
		if (req.getMethod().equals("OPTIONS"))
			res.setStatus(200);
		
		return res;
	}
}