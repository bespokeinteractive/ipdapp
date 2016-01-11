<% ui.decorateWith("appui", "standardEmrPage") %>

<script>
    var jq = jQuery;
    jq(function() {
        jq( "#tabs" ).tabs();
    });
</script>
<style>
    .persondatalabel{
        width:50%;
        border: 1px;
        float: left;
        margin-bottom: 15px;
    }
    .clearboth{
        clear: both;
    }
    .persondatalabel h3{
        display: inline;
        width: 50%;
    }
    .persondatalabel h2{
        display: inline;
        width: 50%;
    }
    .morebuttons{
        display: inline;
        float: left;
        margin-left: 20px;
    }
</style>
</head>
<body>

<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Patient Details</a></li>
        <li><a href="#tabs-2">Daily Vitals</a></li>
        <li><a href="#tabs-3">Treatment</a></li>
        <li><a href="#tabs-4">Transfer</a></li>
    </ul>
    <div id="tabs-1">
        <div class="persondatalabel">
            <h2>Admission Date: </h2>
            <h3> ${ui.formatDatePretty(patientInformation.admissionDate)}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Patient ID: </h2>
            <h3> ${patientInformation.patientIdentifier}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Name: </h2>
            <h3> ${patientInformation.patientName}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Bed Number: </h2>
            <h3> ${patientInformation.bed}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Age: </h2>
            <h3> ${patientInformation.age}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Gender: </h2>
            <h3> ${patientInformation.gender}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Admission By: </h2>
            <h3> ${patientInformation.ipdAdmittedUser.givenName}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Admission Ward :</h2>
            <h3> ${patientInformation.admittedWard.name}</h3>
        </div>

        <div class="clearboth"></div>

        <div style="margin-top: 30px;">
            <a class="button confirm morebuttons">Discharge</a>
            <a class="button confirm morebuttons">Request for Discharge</a>
            <a class="button confirm morebuttons">Abscord</a>
            <a class="button confirm morebuttons">Print</a>
            <div class="clearboth"></div>
        </div>
    </div>
    <div id="tabs-2">
        <section>
            <form>
            <div class="simple-form-ui">
                <div class="persondatalabel">
                    <h2>S.No:</h2>
                    <h3>...</h3>
                </div>
                <div class="persondatalabel">
                    <h2>Date/Time:</h2>
                    <h3> ....</h3>
                </div>
                <div class="persondatalabel">
                    <h2>Blood Pressure</h2>
                    <input type="number">
                </div>
                <div class="persondatalabel">
                    <h2>Pulse Rate(/min)</h2>
                    <input type="number">
                </div>
                <div class="persondatalabel">
                    <h2>Diet Advised</h2>
                    <select>
                        <option>Item 1</option>
                        <option>Item 2</option>
                        <option>Item 3</option>
                    </select>
                </div>
                <div class="persondatalabel">
                    <h2>Temperature(C)</h2>
                    <p>
                     <input placeholder="Temperature"  type="number"> </input>
                    </p>
                </div>
                <div class="clearboth"></div>
                <div class="">
                    <h2>Notes if any</h2>
                    <textarea></textarea>
                </div>
                <div class="" style="margin-top:15px" >
                    <a class="button confirm">Submit</a>
                </div>

            </div>
            </form>
        </section>
    </div>
    <div id="tabs-3">
        <form method="post">
            <div>
                <p class="input-position-class">
                    <label for="procedure">Post for Procedure:</label>
                    <input type="text" id="procedure" name="procedure" />
                </p>
                <div data-bind="foreach: procedures">
                    <p data-bind="text: label"></p>
                    <span data-bind="if: schedulable">Schedule:<input type="date"></span>
                    <button data-bind="click: \$root.removeProcedure">Remove</button>
                </div>
            </div>

            </form>
        <div>
            <p class="input-position-class">
                <label for="investigation">Investigation:</label>
                <input type="text" id="investigation" name="investigation" />
            </p>
            <div data-bind="foreach: investigations">
                <p data-bind="text: label"></p>
                <button data-bind="click: \$root.removeInvestigation">Remove</button>
            </div>
        </div>
        <p class="input-position-class prescription">
            <label>Prescription</label>
        <table>
            <thead>
            <th>Drug Name</th>
            <th>Formulation</th>
            <th>Frequency</th>
            <th>Number of Days</th>
            <th>Comment</th>
            <th></th>
            </thead>
            <tbody data-bind="foreach: drugs">
            <td>
                <input class="drug-name" type="text" data-bind="value: name, valueUpdate: 'blur'" >
            </td>
            <td>
                <select data-bind="options: formulationOpts, value: formulation, optionsText: 'label'"></select>
            </td>
            <td>
                <select data-bind="options: \$root.frequencyOpts, value: frequency, optionsText: 'label'"></select>
            </td>
            <td>
                <input type="text" data-bind="value: numberOfDays" >
            </td>
            <td>
                <textarea data-bind="value: comment"></textarea>
            </td>
            <td>
                <button data-bind="click: \$root.removeDrug">Remove</button>
            </td>
            </tbody>
        </table>
        <button data-bind="click: addDrug">Add</button>
    </p>
        <p class="input-position-class">
            <label for="note">Other Instructions</label>
            <input  data-bind="value: \$root.otherInstructions" type="text" id="note" name="note" />
        </p>

    </div>
    <div id="tabs-4">
        <section>
            <form>
                <div class="simple-form-ui">
                    <div class="persondatalabel">
                        <h2>Select Ward: </h2>
                        <select id="ipdWard"  name="ipdWard"  style="width: 150px;">
                            <option value="">Select Ward</option>
                            <% if (listIpd!=null && listIpd!="") { %>
                            <% listIpd.each { ipd -> %>
                            <option title="${ipd.answerConcept.name}"   value="${ipd.answerConcept.id}">
                                ${ipd.answerConcept.name}
                            </option>
                            <%}%>
                            <%}%>
                        </select>
                    </div>
                    <div class="persondatalabel">
                        <h2>Select Doctor: </h2>
                        <select id="doctor"  name="doctor"  >
                            <option value="">Select Doctor On Call</option>
                            <% if (listDoctor!=null && listDoctor!=""){ %>
                            <% listDoctor.each { doct -> %>
                            <option title="${doct.givenName}"   value="${doct.id}">
                                ${doct.givenName}
                            </option>
                            <% } %>
                            <% } %>
                        </select>
                    </div>
                    <div class="persondatalabel">
                        <h2>Bed Number</h2>
                        <input type="number">
                    </div>

                    <div class="persondatalabel" >
                        <h2>Comments</h2>
                        <textarea></textarea>
                    </div>
                    <div class="persondatalabel" >
                        <a class="button confirm">Submit</a>
                    </div>
                </div>
            </form>
        </section>
    </div>
</div>
