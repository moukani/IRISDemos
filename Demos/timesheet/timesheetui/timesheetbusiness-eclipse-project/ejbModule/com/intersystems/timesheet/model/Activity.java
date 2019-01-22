package com.intersystems.timesheet.model;

import java.io.Serializable;
import javax.persistence.*;
import java.util.List;


@Entity
@Table(name="Timesheet.Activity", schema="\"Timesheet\"")
@NamedQuery(name="Activity.findAll", query="SELECT a FROM Activity a")
public class Activity implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private Integer id;

	@Column(name="\"Completed\"")
	private boolean completed;

	@Column(name="\"Title\"")
	private String title;

	@ManyToOne
	@JoinColumn(name="\"ActivityType\"")
	private ActivityType activityType = new ActivityType();

	@ManyToOne
	@JoinColumn(name="\"Project\"")
	private Project project = new Project();

	@OneToMany(mappedBy="activity")
	private List<WorkItem> workItems;

	public Activity() {
	
	}
	
	public Activity(String title, ActivityType activityType, Project project, boolean completed) {
		super();
		this.title = title;
		this.activityType = activityType;
		this.project = project;
		this.completed = completed;
	}



	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public boolean isCompleted() {
		return completed;
	}

	public void setCompleted(boolean completed) {
		this.completed = completed;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public ActivityType getActivityType() {
		return activityType;
	}

	public void setActivityType(ActivityType activityType) {
		this.activityType = activityType;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public List<WorkItem> getWorkItems() {
		return workItems;
	}

	public void setWorkItems(List<WorkItem> workItems) {
		this.workItems = workItems;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Activity other = (Activity) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return title;
	}
	
	
}