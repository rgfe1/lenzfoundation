<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contact_Info_Changed</fullName>
        <description>Contact Info Changed</description>
        <protected>false</protected>
        <recipients>
            <recipient>jsteinberg@fredericklenzfoundation.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notify_Admin_of_Contact_Info_Change_on_Grant_Report</template>
    </alerts>
    <fieldUpdates>
        <fullName>Contact_Info_Changed</fullName>
        <field>Contact_Info_Has_Changed__c</field>
        <literalValue>1</literalValue>
        <name>Contact Info Changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contact Info Changed</fullName>
        <actions>
            <name>Contact_Info_Changed</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Contact_Info_Changed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Grant_Report__c.Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Grant_Report__c.Full_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Grant_Report__c.Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Grant_Report__c.Phone__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Grant_Report__c.Title__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set contact info changed flag to true if at least one of the contact fields is not blank</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
