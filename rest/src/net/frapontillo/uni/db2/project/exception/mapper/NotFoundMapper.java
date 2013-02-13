package net.frapontillo.uni.db2.project.exception.mapper;

import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import net.frapontillo.uni.db2.project.exception.NotFoundException;

@Provider
public class NotFoundMapper implements ExceptionMapper<NotFoundException> {
	@Override
	public Response toResponse(NotFoundException ex) {
		return Response.
				status(Status.NOT_FOUND).
				type(MediaType.TEXT_PLAIN).
				entity(ex.getMessage()).
				build();
	}
}
