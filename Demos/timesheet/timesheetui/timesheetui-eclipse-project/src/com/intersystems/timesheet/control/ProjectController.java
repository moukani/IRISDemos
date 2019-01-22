package com.intersystems.timesheet.control;


import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.inject.Named;

import org.primefaces.event.SelectEvent;

import com.intersystems.timesheet.business.ProjectService;
import com.intersystems.timesheet.model.Project;
import com.intersystems.timesheet.util.FacesUtil;


@Named (value = "projectController")
@ViewScoped
public class ProjectController implements Serializable {

	private static final long serialVersionUID = 1L;

	@Inject
	private ProjectService projectService;
	
	private Project project = new Project();
	
	private List<Project> projects = new ArrayList<Project>();
	
	public String merge() {

		try {
			project = projectService.merge(project);
			FacesUtil.infoMessage("Successful post", "Project saved successfully");
		} catch (Exception e) {
			project = new Project();
			FacesUtil.errorMessage("Unsuccessful post", "Error details: " + e.getMessage());
		}
		

		return null;
	}
	
	public String reset() {

		project = new Project();

		return null;
	}
	
	public String delete() {

		try {
			projectService.remove(project.getId());
			project = new Project();
			getProjectList();
			FacesUtil.infoMessage("Successful deletion", "Project deleted successfully");
		} catch (Exception e) {
			project = new Project();
			FacesUtil.errorMessage("Unsuccessful deletion", "Error details: " + e.getMessage());
		}
		
		return null;
	}
	
	public String list() {

		try {
			getProjectList(project);
		} catch (Exception e) {
			project = new Project();
			FacesUtil.errorMessage("Unsuccessful query", "Error details: " + e.getMessage());
		}

		return null;

	}
	
	private void getProjectList(Project project) {
		projects.clear();
		projects.addAll(projectService.getProjectList(project));
	}

	
	public List<Project> getProjectList() {
		return projectService.getProjectList();
	}
	
	public void onRowSelect(SelectEvent event) {
        project = projectService.load(((Project) event.getObject()).getId());
    }
	
	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public List<Project> getProjects() {
		return projects;
	}

	public void setProjects(List<Project> projects) {
		this.projects = projects;
	}
	
}
