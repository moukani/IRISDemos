package com.intersystems.timesheet.control;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.Month;
import java.util.List;
import java.util.Random;

import javax.faces.view.ViewScoped;
import javax.inject.Inject;
import javax.inject.Named;

import com.intersystems.timesheet.business.ActivityService;
import com.intersystems.timesheet.business.ActivityTypeService;
import com.intersystems.timesheet.business.MemberService;
import com.intersystems.timesheet.business.ProjectService;
import com.intersystems.timesheet.business.TeamService;
import com.intersystems.timesheet.business.TimesheetService;
import com.intersystems.timesheet.model.Activity;
import com.intersystems.timesheet.model.ActivityType;
import com.intersystems.timesheet.model.Member;
import com.intersystems.timesheet.model.Project;
import com.intersystems.timesheet.model.Team;
import com.intersystems.timesheet.model.WorkItem;

@Named(value = "loadDataController")
@ViewScoped
public class LoadDataController implements Serializable {

	private static final long serialVersionUID = 1L;

	@Inject
	private MemberService memberService;

	@Inject
	private TeamService teamService;

	@Inject
	private ActivityTypeService activityTypeService;

	@Inject
	private ProjectService projectService;

	@Inject
	private ActivityService activityService;

	@Inject
	private TimesheetService timesheetService;

	public String loadData() {

		Team teamJava = teamService.merge(new Team("Java Team", "Java"));
		Team teamIRIS = teamService.merge(new Team("IRIS Team", "IRIS"));

		String[] membersJava = { "Simon", "John", "Helen" };

		String[] membersIRIS = { "Michael", "Maria" };

		for (String name : membersJava) {
			Member member = new Member(name.toLowerCase() + "@" + "acme.com", name,
					new Double(getRandomNumberInRange(70, 100)), "123", isManager());
			member.getTeams().add(teamJava);
			memberService.merge(member);
		}

		for (String name : membersIRIS) {
			Member member = new Member(name.toLowerCase() + "@" + "acme.com", name,
					new Double(getRandomNumberInRange(70, 100)), "123", isManager());
			member.getTeams().add(teamIRIS);
			memberService.merge(member);
		}

		Member boss = new Member("boss@acme.com", "Boss", 120.0, "123", true);
		boss.getTeams().add(teamJava);
		boss.getTeams().add(teamIRIS);
		memberService.merge(boss);

		ActivityType businessModeling = activityTypeService
				.merge(new ActivityType("Business Modelling", "Business Modelling activity type"));

		ActivityType requirements = activityTypeService
				.merge(new ActivityType("Requirements", "Requirements activity type"));

		ActivityType analysis = activityTypeService
				.merge(new ActivityType("Analysis and Design", "Analysis and Design activity type"));

		ActivityType implementation = activityTypeService
				.merge(new ActivityType("Implementation", "Implementation activity type"));

		ActivityType test = activityTypeService.merge(new ActivityType("Test", "Test activity type"));

		ActivityType deploy = activityTypeService.merge(new ActivityType("Deployment", "Deployment activity type"));

		ActivityType config = activityTypeService.merge(new ActivityType("Configuration and Change Management",
				"Configuration and Change Management activity type"));

		ActivityType management = activityTypeService
				.merge(new ActivityType("Project Management", "Project Management activity type"));

		ActivityType environment = activityTypeService
				.merge(new ActivityType("Environment", "Environment activity type"));

		Project acmeWebsite = projectService.merge(new Project("Project to construct Acme Website", "Acme Website"));

		Project acmePayroll = projectService
				.merge(new Project("Project to construct Acme Payroll system", "Acme Payroll System"));

		Project acmeSales = projectService
				.merge(new Project("Project to construct Acme Sales System", "Acme Sales System"));

		String[] activitiesBusinessModeling = { "Assess Business Status", "Describe Current Business",
				"Identify Business Processes", "Refine Business Process Definitions", "Explore Process Automation",
				"Develop a Domain Model", "Design Business Process Realizations", "Refine Roles and Responsibilities" };

		String[] activitiesRequirements = { "Analyze the Problem", "Understand Stakeholder Needs",
				"Manage Changing Requirements", "Define the System", "Manage the Scope of the System",
				"Refine the System Definition" };

		String[] activitiesAnalysis = { "Define a Candidate Architecture", "Perform Architectural Synthesis",
				"Analyze Behavior", "Refine the Architecture", "Design Components", "Design the Database" };

		String[] activitiesImplementation = { "Structure the Implementation Model", "Plan the Integration",
				"Implement Components", "Integrate Each Subsystem", "Integrate the System" };

		String[] activitiesTest = { "Define Evaluation Mission", "Verify Test Approach", "Validate Build Stability",
				"Test and Evaluate", "Achieve Acceptable Mission", "Improve Test Assets" };

		String[] activitiesDeploy = { "Plan Deployment", "Develop Support Material", "Manage Acceptance Test",
				"Produce Deployment Unit", "Beta Test Product", "Manage Acceptance Test", "Package Product",
				"Provide Access to Download Site" };

		String[] activitiesConfig = { "Plan Project Configuration & Change Control",
				"Create Project Configuration Management (CM) Environments", "Change and Deliver Configuration Items",
				"Manage Baselines & Releases", "Monitor & Report Configuration Status", "Manage Change Requests" };

		String[] activitiesManagement = { "Conceive New Project", "Evaluate Project Scope and Risk",
				"Develop Software Development Plan", "Plan for Next Iteration", "Manage Iteration", "Close-Out Project",
				"Close-Out Phase", "Monitor & Control Project" };

		String[] activitiesEnvironment = { "Prepare Environment for Project", "Prepare Environment for an Iteration",
				"Prepare Guidelines for an Iteration", "Support Environment During an Iteration" };

		for (String title : activitiesBusinessModeling) {
			Activity activity = new Activity(title, businessModeling, acmeWebsite, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesBusinessModeling) {
			Activity activity = new Activity(title, businessModeling, acmePayroll, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesBusinessModeling) {
			Activity activity = new Activity(title, businessModeling, acmeSales, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesRequirements) {
			Activity activity = new Activity(title, requirements, acmeWebsite, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesRequirements) {
			Activity activity = new Activity(title, requirements, acmePayroll, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesRequirements) {
			Activity activity = new Activity(title, requirements, acmeSales, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesAnalysis) {
			Activity activity = new Activity(title, analysis, acmeWebsite, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesAnalysis) {
			Activity activity = new Activity(title, analysis, acmePayroll, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesAnalysis) {
			Activity activity = new Activity(title, analysis, acmeSales, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesImplementation) {
			Activity activity = new Activity(title, implementation, acmeWebsite, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesImplementation) {
			Activity activity = new Activity(title, implementation, acmePayroll, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesImplementation) {
			Activity activity = new Activity(title, implementation, acmeSales, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesTest) {
			Activity activity = new Activity(title, test, acmeWebsite, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesTest) {
			Activity activity = new Activity(title, test, acmePayroll, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesTest) {
			Activity activity = new Activity(title, test, acmeSales, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesDeploy) {
			Activity activity = new Activity(title, deploy, acmeWebsite, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesDeploy) {
			Activity activity = new Activity(title, deploy, acmePayroll, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesDeploy) {
			Activity activity = new Activity(title, deploy, acmeSales, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesConfig) {
			Activity activity = new Activity(title, config, acmeWebsite, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesConfig) {
			Activity activity = new Activity(title, config, acmePayroll, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesConfig) {
			Activity activity = new Activity(title, config, acmeSales, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesManagement) {
			Activity activity = new Activity(title, management, acmeWebsite, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesManagement) {
			Activity activity = new Activity(title, management, acmePayroll, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesManagement) {
			Activity activity = new Activity(title, management, acmeSales, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesEnvironment) {
			Activity activity = new Activity(title, environment, acmeWebsite, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesEnvironment) {
			Activity activity = new Activity(title, environment, acmePayroll, isCompleted());
			activityService.merge(activity);
		}

		for (String title : activitiesEnvironment) {
			Activity activity = new Activity(title, environment, acmeSales, isCompleted());
			activityService.merge(activity);
		}

		// timesheet generation for website project
		generateTimesheet(LocalDateTime.of(2014, Month.DECEMBER, 12, 8, 0, 0), 704, businessModeling.getId(),acmeWebsite.getId());
		generateTimesheet(LocalDateTime.of(2015, Month.JANUARY, 02, 8, 0, 0), 1408, requirements.getId(),acmeWebsite.getId());
		generateTimesheet(LocalDateTime.of(2015, Month.FEBRUARY, 01, 8, 0, 0), 1056, analysis.getId(),acmeWebsite.getId());
		generateTimesheet(LocalDateTime.of(2015, Month.FEBRUARY, 01, 8, 0, 0), 2112, implementation.getId(),acmeWebsite.getId());
		generateTimesheet(LocalDateTime.of(2015, Month.MAY, 02, 8, 0, 0), 704, test.getId(), acmeWebsite.getId());
		generateTimesheet(LocalDateTime.of(2015, Month.JUNE, 01, 8, 0, 0), 282, deploy.getId(), acmeWebsite.getId());
		generateTimesheet(LocalDateTime.of(2015, Month.JUNE, 01, 8, 0, 0), 282, config.getId(), acmeWebsite.getId());
		generateTimesheet(LocalDateTime.of(2015, Month.MARCH, 01, 8, 0, 0), 352, management.getId(),acmeWebsite.getId());
		generateTimesheet(LocalDateTime.of(2015, Month.JULY, 01, 8, 0, 0), 141, environment.getId(),acmeWebsite.getId());

		// timesheet generation for payroll project
		generateTimesheet(LocalDateTime.of(2015, Month.DECEMBER, 12, 8, 0, 0), 2112, businessModeling.getId(),acmePayroll.getId());
		generateTimesheet(LocalDateTime.of(2016, Month.JANUARY, 02, 8, 0, 0), 4224, requirements.getId(),acmePayroll.getId());
		generateTimesheet(LocalDateTime.of(2016, Month.FEBRUARY, 01, 8, 0, 0), 3168, analysis.getId(),acmePayroll.getId());
		generateTimesheet(LocalDateTime.of(2016, Month.FEBRUARY, 01, 8, 0, 0), 6336, implementation.getId(),acmePayroll.getId());
		generateTimesheet(LocalDateTime.of(2017, Month.MAY, 02, 8, 0, 0), 2112, test.getId(), acmePayroll.getId());
		generateTimesheet(LocalDateTime.of(2017, Month.JUNE, 01, 8, 0, 0), 845, deploy.getId(), acmePayroll.getId());
		generateTimesheet(LocalDateTime.of(2017, Month.JUNE, 01, 8, 0, 0), 845, config.getId(), acmePayroll.getId());
		generateTimesheet(LocalDateTime.of(2017, Month.MARCH, 01, 8, 0, 0), 1056, management.getId(),acmePayroll.getId());
		generateTimesheet(LocalDateTime.of(2017, Month.JULY, 01, 8, 0, 0), 422, environment.getId(),acmePayroll.getId());

		// timesheet generation for sales project
		generateTimesheet(LocalDateTime.of(2017, Month.DECEMBER, 12, 8, 0, 0), 986, businessModeling.getId(),acmeSales.getId());
		generateTimesheet(LocalDateTime.of(2018, Month.JANUARY, 02, 8, 0, 0), 1971, requirements.getId(),acmeSales.getId());
		generateTimesheet(LocalDateTime.of(2018, Month.FEBRUARY, 01, 8, 0, 0), 1478, analysis.getId(),acmeSales.getId());
		generateTimesheet(LocalDateTime.of(2018, Month.FEBRUARY, 01, 8, 0, 0), 2957, implementation.getId(),acmeSales.getId());
		generateTimesheet(LocalDateTime.of(2018, Month.MAY, 02, 8, 0, 0), 986, test.getId(), acmeSales.getId());
		generateTimesheet(LocalDateTime.of(2018, Month.JUNE, 01, 8, 0, 0), 394, deploy.getId(), acmeSales.getId());
		generateTimesheet(LocalDateTime.of(2018, Month.JUNE, 01, 8, 0, 0), 394, config.getId(), acmeSales.getId());
		generateTimesheet(LocalDateTime.of(2018, Month.MARCH, 01, 8, 0, 0), 493, management.getId(),acmeSales.getId());
		generateTimesheet(LocalDateTime.of(2018, Month.JULY, 01, 8, 0, 0), 197, environment.getId(),acmeSales.getId());

		return null;
	}

	private void generateTimesheet(LocalDateTime initialDateTime, Integer totalEffort, Integer activityType,
			Integer project) {

		List<Member> members = memberService.getMemberList();
		List<Activity> activities = activityService.getActivityList(activityType, project);
		Integer effort = totalEffort;

		Integer randomEffort = getRandomNumberInRange(1, 4);
		LocalDateTime startDateTime = initialDateTime;
		LocalDateTime endDateTime = startDateTime.plusHours(randomEffort);

		for (Member member : members) {
			for (Activity activity : activities) {
				timesheetService.merge(new WorkItem(member, java.sql.Timestamp.valueOf(startDateTime),
						java.sql.Timestamp.valueOf(endDateTime), activity, new Double(randomEffort), randomEffort * member.getCost(),
						"Worked in " + activity.getTitle() + " on the project " + activity.getProject()));
				effort = effort - randomEffort;
				startDateTime = endDateTime;
				randomEffort = getRandomNumberInRange(1, 4);
				endDateTime = endDateTime.plusHours(randomEffort);

				if (effort < 0) {
					break;
				}

			}

			if (effort < 0) {
				break;
			}

		}
	}

	private static Boolean isManager() {
		return Math.random() < 0.5;
	}

	private static Boolean isCompleted() {
		return Math.random() < 0.5;
	}

	private static int getRandomNumberInRange(int min, int max) {

		if (min >= max) {
			throw new IllegalArgumentException("max must be greater than min");
		}

		Random r = new Random();
		return r.nextInt((max - min) + 1) + min;
	}

}
