package org.openmrs.module.ipdui.fragment.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.*;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.hospitalcore.util.ConceptComparator;
import org.openmrs.module.ipdui.model.Procedure;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/**
 * Created by Francis on 1/12/2016.
 */
public class PatientInfoFragmentController {
    //get the list of procedures starting with a certain string
    public List<SimpleObject> getProcedures(@RequestParam(value = "q") String name, UiUtils ui) {
        List<Concept> procedures = Context.getService(PatientDashboardService.class).searchProcedure(name);
        List<Procedure> proceduresPriority = new ArrayList<Procedure>();
        for (Concept myConcept : procedures) {
            proceduresPriority.add(new Procedure(myConcept));
        }

        List<SimpleObject> proceduresList = SimpleObject.fromCollection(proceduresPriority, ui, "id", "label", "schedulable");
        return proceduresList;
    }
    public List<SimpleObject> getInvestigations(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> investigations = Context.getService(PatientDashboardService.class).searchInvestigation(name);
        List<SimpleObject> investigationsList = SimpleObject.fromCollection(investigations, ui, "id", "name");
        return investigationsList;
    }
    public List<SimpleObject> getDrugs(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<InventoryDrug> drugs = Context.getService(PatientDashboardService.class).findDrug(name);
        List<SimpleObject> drugList = SimpleObject.fromCollection(drugs, ui, "id", "name");
        return drugList;
    }
    public List<SimpleObject> getFormulationByDrugName(@RequestParam(value="drugName") String drugName,UiUtils ui)
    {

        InventoryCommonService inventoryCommonService = (InventoryCommonService) Context.getService(InventoryCommonService.class);
        InventoryDrug drug = inventoryCommonService.getDrugByName(drugName);

        List<SimpleObject> formulationsList = null;

        if(drug != null){
            List<InventoryDrugFormulation> formulations = new ArrayList<InventoryDrugFormulation>(drug.getFormulations());
            formulationsList = SimpleObject.fromCollection(formulations, ui, "id", "name");
        }

        return formulationsList;
    }
    
    public void requestForDischarge(@RequestParam(value = "id", required = false) Integer admittedId,
                                    @RequestParam(value = "ipdWard", required = false) String ipdWard,
                                    @RequestParam(value = "obStatus", required = false) Integer obStatus) {

        int requestForDischargeStatus = 1;
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        IpdPatientAdmitted admitted = ipdService.getIpdPatientAdmitted(admittedId);

        IpdPatientAdmissionLog ipal = admitted.getPatientAdmissionLog();
        ipal.setAbsconded(obStatus);

        admitted.setRequestForDischargeStatus(requestForDischargeStatus);
        admitted.setAbsconded(obStatus);

        if(obStatus==1){
            Date date = new Date();
            admitted.setAbscondedDate(date);
        }

        admitted=ipdService.saveIpdPatientAdmitted(admitted);
        IpdPatientAdmissionLog ipdPatientAdmissionLog=admitted.getPatientAdmissionLog();
        ipdPatientAdmissionLog.setRequestForDischargeStatus(requestForDischargeStatus);
        ipdService.saveIpdPatientAdmissionLog(ipdPatientAdmissionLog);
    }

    public void transferPatient(@RequestParam("admittedId") Integer id,
                                @RequestParam("toWard") Integer toWardId,
                                @RequestParam("doctor") Integer doctorId,
                                @RequestParam(value = "bedNumber", required = false) String bed,
                                @RequestParam(value = "comments", required = false) String comments,
                                PageModel model){
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        ipdService.transfer(id, toWardId, doctorId, bed,comments);

    }
    public void saveVitalStatistics(@RequestParam("admittedId") Integer admittedId,
                                    @RequestParam("patientId") Integer patientId,
                                    @RequestParam(value = "bloodPressure", required = false) String bloodPressure,
                                    @RequestParam(value = "pulseRate", required = false) String pulseRate,
                                    @RequestParam(value = "temperature", required = false) String temperature,
                                    @RequestParam(value = "dietAdvised", required = false) String dietAdvised,
                                    @RequestParam(value = "notes", required = false) String notes,
                                    @RequestParam(value = "ipdWard", required = false) String ipdWard,PageModel model)
    {
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        PatientService patientService = Context.getPatientService();
        Patient patient = patientService.getPatient(patientId);
        IpdPatientAdmitted admitted = ipdService.getIpdPatientAdmitted(admittedId);
        IpdPatientVitalStatistics ipdPatientVitalStatistics=new IpdPatientVitalStatistics();
        ipdPatientVitalStatistics.setPatient(patient);
        ipdPatientVitalStatistics.setIpdPatientAdmissionLog(admitted.getPatientAdmissionLog());
        ipdPatientVitalStatistics.setBloodPressure(bloodPressure);
        ipdPatientVitalStatistics.setPulseRate(pulseRate);
        ipdPatientVitalStatistics.setTemperature(temperature);
        ipdPatientVitalStatistics.setDietAdvised(dietAdvised);
        ipdPatientVitalStatistics.setNote(notes);
        ipdPatientVitalStatistics.setCreator(Context.getAuthenticatedUser().getUserId());
        ipdPatientVitalStatistics.setCreatedOn(new Date());
        ipdService.saveIpdPatientVitalStatistics(ipdPatientVitalStatistics);
    }
}
