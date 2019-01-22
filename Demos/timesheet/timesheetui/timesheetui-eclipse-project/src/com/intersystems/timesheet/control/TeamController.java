package com.intersystems.timesheet.control;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.inject.Named;

import org.primefaces.event.SelectEvent;

import com.intersystems.timesheet.business.TeamService;
import com.intersystems.timesheet.model.Team;
import com.intersystems.timesheet.util.FacesUtil;

@Named(value = "teamController")
@ViewScoped
public class TeamController implements Serializable {

	private static final long serialVersionUID = 1L;

	@Inject
	private TeamService teamService;

	private Team team = new Team();
	
	private List<Team> teams = new ArrayList<Team>();
	
	public String merge() {

		try {
			team = teamService.merge(team);
			FacesUtil.infoMessage("Successful post", "Team saved successfully");
		} catch (Exception e) {
			team = new Team();
			FacesUtil.errorMessage("Unsuccessful post", "Error details: " + e.getMessage());
		}

		return null;
	}

	public String reset() {

		team = new Team();

		return null;
	}

	public String delete() {

		try {
			teamService.remove(team.getId());
			team = new Team();
			getTeamList();
			FacesUtil.infoMessage("Successful deletion", "Team deleted successfully");
		} catch (Exception e) {
			team = new Team();
			FacesUtil.errorMessage("Unsuccessful deletion", "Error details: " + e.getMessage());
		}

		return null;
	}

	public String list() {

		try {
			getTeamList(team);
		} catch (Exception e) {
			team = new Team();
			FacesUtil.errorMessage("Unsuccessful query", "Error details: " + e.getMessage());
		}

		return null;

	}
	
	private void getTeamList(Team team) {
		teams.clear();
		teams.addAll(teamService.getTeamList(team));
	}

	public List<Team> getTeamList() {
		return teamService.getTeamList();
	}

	public void onRowSelect(SelectEvent event) {
		team = teamService.load(((Team) event.getObject()).getId());
	}

	public Team getTeam() {
		return team;
	}

	public void setTeam(Team team) {
		this.team = team;
	}

	public List<Team> getTeams() {
		return teams;
	}

	public void setTeams(List<Team> teams) {
		this.teams = teams;
	}

}
