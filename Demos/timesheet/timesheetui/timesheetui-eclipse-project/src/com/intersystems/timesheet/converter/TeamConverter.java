package com.intersystems.timesheet.converter;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.faces.convert.FacesConverter;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import com.intersystems.timesheet.business.TeamService;
import com.intersystems.timesheet.model.Team;

@SuppressWarnings("rawtypes")
@FacesConverter(value="teamConverter")
public class TeamConverter implements Converter {

	private TeamService teamService;
	
	public TeamConverter() {
		super();  
        try {  
            InitialContext ic = new InitialContext();  
            teamService = (TeamService) ic.lookup("java:module/TeamService");  
           } catch (NamingException e) {  
            e.printStackTrace();  
       }  
	}

	@Override
	public Object getAsObject(FacesContext context, UIComponent component, String value) {
		Team team = teamService.load(new Integer(value));
		return team;
	}

	@Override
	public String getAsString(FacesContext context, UIComponent component, Object value) {
		Team team = (Team) value;
		String result = team.getId().toString();
		return  result;
	}

}
