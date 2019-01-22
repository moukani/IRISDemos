package com.intersystems.timesheet.util;

import java.io.IOException;

import javax.inject.Inject;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.intersystems.timesheet.control.UserController;

@WebFilter("/pages/*")
public class SessionFilter implements Filter {

	@Inject
	UserController userController;

	public SessionFilter() {
	
	}

	public void destroy() {
	
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		
		if (req.getRequestURI().contains("login.xhtml")) {
			chain.doFilter(request, response);
		} else if (userController != null && userController.getUserSession() != null
				&& userController.getUserSession().getName() != null
				&& !userController.getUserSession().getName().isEmpty()) {
			chain.doFilter(request, response);
		} else {
			String contextPath = ((HttpServletRequest) request).getContextPath();
			((HttpServletResponse) response).sendRedirect(contextPath + "/login.xhtml");
		}

	}

	public void init(FilterConfig fConfig) throws ServletException {
	
	}

}
