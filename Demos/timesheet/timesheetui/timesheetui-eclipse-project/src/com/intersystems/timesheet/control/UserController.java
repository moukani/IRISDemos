package com.intersystems.timesheet.control;

import java.io.Serializable;

import javax.enterprise.context.SessionScoped;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.inject.Inject;
import javax.inject.Named;

import com.intersystems.timesheet.business.MemberService;
import com.intersystems.timesheet.model.Member;
import com.intersystems.timesheet.util.FacesUtil;

@Named(value = "userController")
@SessionScoped
public class UserController implements Serializable {

	private static final long serialVersionUID = 1L;

	@Inject
	private MemberService memberService;

	private Member userSession = new Member();

	public String login() {

		try {
			userSession = memberService.getMemberByUserAndPassword(userSession.getEmail(), userSession.getPassword());
			if(userSession == null || !userSession.getName().isEmpty()) {
				
				String url = "/pages/index.xhtml";
				FacesContext fc = FacesContext.getCurrentInstance();
				ExternalContext ec = fc.getExternalContext();
				ec.redirect(ec.getRequestContextPath() + url);
				
				return "";
			} else {
				FacesUtil.errorMessage("Login Error", "Email and password not match");
				return "login";
			}
			
		} catch (Exception e) {
			userSession = new Member();
			FacesUtil.errorMessage("Unsuccessful login", "Error details: " + " email and password not matches");
			return "login";
		}
		
	}

	public String reset() {

		userSession = new Member();
		return null;

	}

	public Member getUserSession() {
		return userSession;
	}

	public void setUserSession(Member userSession) {
		this.userSession = userSession;
	}

}
