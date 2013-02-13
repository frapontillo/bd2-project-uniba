package net.frapontillo.uni.db2.project.exception.mapper;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import net.frapontillo.uni.db2.project.exception.UnauthorizedException;

@Provider
public class UnauthorizedMapper implements ExceptionMapper<UnauthorizedException> {
	@Override
	public Response toResponse(UnauthorizedException ex) {
		return Response.
				status(Status.UNAUTHORIZED).
				type(MediaType.TEXT_PLAIN).
				entity(ex.getMessage()).
				build();
	}
}
