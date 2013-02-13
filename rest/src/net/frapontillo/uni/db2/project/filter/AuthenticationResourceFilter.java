package net.frapontillo.uni.db2.project.filter;

import javax.ws.rs.ext.Provider;

import net.frapontillo.uni.db2.project.exception.UnauthorizedException;

import com.sun.jersey.spi.container.ContainerRequest;
import com.sun.jersey.spi.container.ContainerRequestFilter;
import com.sun.jersey.spi.container.ContainerResponseFilter;
import com.sun.jersey.spi.container.ResourceFilter;

@Provider
public class AuthenticationResourceFilter implements ResourceFilter, ContainerRequestFilter {

	@Override
	public ContainerRequest filter(ContainerRequest req) {
		String authcode = req.getQueryParameters().getFirst("authcode");
		// TODO: gestire codice lato DB
		if (authcode == null || authcode == "")
			throw new UnauthorizedException();
		return req;
	}

	@Override
	public ContainerRequestFilter getRequestFilter() {
		return this;
	}

	@Override
	public ContainerResponseFilter getResponseFilter() {
		return null;
	}

}
