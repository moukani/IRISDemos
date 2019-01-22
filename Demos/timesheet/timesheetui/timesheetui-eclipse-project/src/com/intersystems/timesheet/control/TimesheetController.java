package com.intersystems.timesheet.control;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.inject.Named;

import org.primefaces.event.SelectEvent;

import com.intersystems.timesheet.business.ActivityService;
import com.intersystems.timesheet.business.ActivityTypeService;
import com.intersystems.timesheet.business.MemberService;
import com.intersystems.timesheet.business.ProjectService;
import com.intersystems.timesheet.business.TimesheetService;
import com.intersystems.timesheet.model.Activity;
import com.intersystems.timesheet.model.ActivityType;
import com.intersystems.timesheet.model.Project;
import com.intersystems.timesheet.model.WorkItem;
import com.intersystems.timesheet.util.FacesUtil;

@Named(value = "timesheetController")
@ViewScoped
public class TimesheetController implements Serializable {

	private static final long serialVersionUID = 1L;

	@Inject
	private TimesheetService timesheetService;

	@Inject
	private ActivityTypeService activityTypeService;

	@Inject
	private ActivityService activityService;
	
	@Inject
	private ProjectService projectService;
	
	@Inject
	private MemberService memberService;
	
	@Inject
	private UserController userController;

	private WorkItem workItem = new WorkItem();

	private List<WorkItem> workItems = new ArrayList<WorkItem>();

	private List<Activity> activities = new ArrayList<Activity>();

	private Boolean clearAll;
	
	public String merge() {

		try {
			workItem.setMember(memberService.load(userController.getUserSession().getId()));
			workItem = timesheetService.merge(workItem);
			getWorkItemList(workItem);
			FacesUtil.infoMessage("Successful post", "Timesheet saved successfully");
		} catch (Exception e) {
			workItem = new WorkItem();
			FacesUtil.errorMessage("Unsuccessful post", "Error details: " + e.getMessage());
		}

		return null;
	}

	public String reset() {

		clearFields();		

		return null;
	}

	private void clearFields() {
		if(clearAll) {
			workItem = new WorkItem();
		} else {
			workItem.setNotes("");
		}
	}

	public String delete() {

		try {
			timesheetService.remove(workItem.getId());
			workItem = new WorkItem();
			getTimesheetList();
			FacesUtil.infoMessage("Successful deletion", "Timesheet deleted successfully");
		} catch (Exception e) {
			workItem = new WorkItem();
			FacesUtil.errorMessage("Unsuccessful deletion", "Error details: " + e.getMessage());
		}

		return null;
	}

	public String list() {

		try {
			getWorkItemList(workItem);
		} catch (Exception e) {
			workItem = new WorkItem();
			FacesUtil.errorMessage("Unsuccessful query", "Error details: " + e.getMessage());
		}

		return null;

	}

	private void getWorkItemList(WorkItem workItem) {
		workItems.clear();
		workItems.addAll(timesheetService.getWorkItemList(workItem));
	}

	public List<ActivityType> getActivityTypeList() {
		return activityTypeService.getActivityTypeList();
	}

	public List<Project> getProjectList() {
		return projectService.getProjectList();
	}

	public List<WorkItem> getTimesheetList() {
		return timesheetService.getWorkItemList();
	}

	public void onRowSelect(SelectEvent event) {
		workItem = timesheetService.load(((WorkItem) event.getObject()).getId());
	}

	public void onProjectChange() {
		activities.clear();
		activities.addAll(activityService.getActivityList(workItem.getActivity().getActivityType().getId(), workItem.getActivity().getProject().getId()));	
	}
	
	public void onActivityTypeChange() {
		activities.clear();
		activities.addAll(activityService.getActivityList(workItem.getActivity().getActivityType().getId(), workItem.getActivity().getProject().getId()));	
	}

	public WorkItem getWorkItem() {
		return workItem;
	}

	public void setWorkItem(WorkItem workItem) {
		this.workItem = workItem;
	}

	public List<WorkItem> getWorkItems() {
		return workItems;
	}

	public void setWorkItems(List<WorkItem> workItems) {
		this.workItems = workItems;
	}

	public List<Activity> getActivities() {
		return activities;
	}

	public void setActivities(List<Activity> activities) {
		this.activities = activities;
	}

	public Boolean getClearAll() {
		return clearAll;
	}

	public void setClearAll(Boolean clearAll) {
		this.clearAll = clearAll;
	}

}
