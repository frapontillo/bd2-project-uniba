package net.frapontillo.uni.db2.project.exception.mapper;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import net.frapontillo.uni.db2.project.exception.BadRequestException;

@Provider
public class BadRequestMapper implements ExceptionMapper<BadRequestException> {
	@Override
	public Response toResponse(BadRequestException ex) {
		return Response.
				status(Status.BAD_REQUEST).
				type(MediaType.TEXT_PLAIN).
				entity(ex.getMessage()).
				build();
	}
}
