public with sharing class CaseController {
    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(Integer maxRecords, String caseNumber, String status) {
        // Safe default limit fallback
        Integer recordLimit = (maxRecords != null && maxRecords > 0) ? maxRecords : 100;
        
        // Base Query
        String query = 'SELECT Id, CaseNumber, Subject, Description, Status FROM Case';
        List<String> whereClauses = new List<String>();
        
        // Bind variables initialized for safe dynamic query binding
        String searchKey = '';
        String statusFilter = '';

        // Safely evaluate and inject filters independently
        if (String.isNotBlank(caseNumber)) {
            searchKey = '%' + caseNumber.trim() + '%';
            whereClauses.add('CaseNumber LIKE :searchKey');
        }
        
        if (String.isNotBlank(status)) {
            statusFilter = status.trim();
            whereClauses.add('Status = :statusFilter');
        }
        
        // Construct WHERE clause if filters are present
        if (!whereClauses.isEmpty()) {
            query += ' WHERE ' + String.join(whereClauses, ' AND ');
        }
        
        query += ' ORDER BY CreatedDate DESC LIMIT :recordLimit';
        
        return Database.query(query);
    }

    @AuraEnabled
    public static String createCase(String caseSubject, String caseDescription) {
        try {
            Case newCase = new Case(Subject = caseSubject, Description = caseDescription);
            insert newCase;
            return JSON.serialize(newCase);
        } catch (Exception e) {
            throw new AuraHandledException('Error creating record: ' + e.getMessage());
        }
    }
}
