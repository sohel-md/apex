public with sharing class CaseController {
    
    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(String searchKey) {
        String query = 'SELECT Id, CaseNumber, Subject, Status, Priority FROM Case WHERE ';
        query += '(CaseNumber LIKE :searchKey OR Subject LIKE :searchKey) ';
        query += 'AND IsDeleted = FALSE ORDER BY CreatedDate DESC';
        
        return Database.query(query);
    }

    @AuraEnabled
    public static void deleteCase(Id caseId) {
        try {
            Case caseToDelete = [SELECT Id FROM Case WHERE Id = :caseId LIMIT 1];
            delete caseToDelete;
        } catch (Exception e) {
            throw new AuraHandledException('Error deleting case: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Case createCase(String subject, String priority, String status) {
        Case newCase = new Case(
            Subject = subject,
            Priority = priority,
            Status = status
        );
        insert newCase;
        return newCase;
    }
}