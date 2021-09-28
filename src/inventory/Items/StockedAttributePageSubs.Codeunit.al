/// <summary>
/// Codeunit StockedAttributePageSubs (ID 50102).
/// </summary>
codeunit 50102 StockedAttributePageSubs
{
    #region Sales

    /// <summary>
    /// SalesQuoteSubform_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Line".</param>
    /// <param name="xRec">VAR Record "Sales Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Sales Quote Subform", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesQuoteSubform_OnAfterValidate_No(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    /// <summary>
    /// SalesOrderSubform_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Line".</param>
    /// <param name="xRec">VAR Record "Sales Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Sales Order Subform", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesOrderSubform_OnAfterValidate_No(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    /// <summary>
    /// SalesInvoiceSubform_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Line".</param>
    /// <param name="xRec">VAR Record "Sales Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Sales Invoice Subform", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesInvoiceSubform_OnAfterValidate_No(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    /// <summary>
    /// SalesCrMemoSubform_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Sales Line".</param>
    /// <param name="xRec">VAR Record "Sales Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Sales Cr. Memo Subform", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure SalesCrMemoSubform_OnAfterValidate_No(var Rec: Record "Sales Line"; var xRec: Record "Sales Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    #endregion

    #region Purchase

    /// <summary>
    /// PurchaseQuoteSubform_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Purchase Line".</param>
    /// <param name="xRec">VAR Record "Purchase Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Purchase Quote Subform", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure PurchaseQuoteSubform_OnAfterValidate_No(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    /// <summary>
    /// PurchaseOrderSubform_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Purchase Line".</param>
    /// <param name="xRec">VAR Record "Purchase Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Purchase Order Subform", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure PurchaseOrderSubform_OnAfterValidate_No(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    /// <summary>
    /// PurchaseInvoiceSubform_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Purchase Line".</param>
    /// <param name="xRec">VAR Record "Purchase Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Purch. Invoice Subform", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure PurchaseInvoiceSubform_OnAfterValidate_No(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    /// <summary>
    /// PurchaseCrMemoSubform_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Purchase Line".</param>
    /// <param name="xRec">VAR Record "Purchase Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Purch. Cr. Memo Subform", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure PurchaseCrMemoSubform_OnAfterValidate_No(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    #endregion

    #region Assembly 

    /// <summary>
    /// TransferOrderSubform_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Transfer Line".</param>
    /// <param name="xRec">VAR Record "Transfer Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Assembly Order Subform", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure AssemblyOrderSubform_OnAfterValidate_No(var Rec: Record "Assembly Line"; var xRec: Record "Assembly Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    #endregion

    #region Transfer

    /// <summary>
    /// ItemJournal_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Item Journal Line".</param>
    /// <param name="xRec">VAR Record "Item Journal Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Transfer Order Subform", 'OnAfterValidateEvent', 'Item No.', true, true)]
    local procedure TransferOrderSubform_OnAfterValidate_No(var Rec: Record "Transfer Line"; var xRec: Record "Transfer Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    #endregion

    #region Item Journal

    /// <summary>
    /// ItemJournal_OnAfterValidate_No.
    /// </summary>
    /// <param name="Rec">VAR Record "Item Journal Line".</param>
    /// <param name="xRec">VAR Record "Item Journal Line".</param>
    [EventSubscriber(ObjectType::Page, Page::"Item Journal", 'OnAfterValidateEvent', 'Item No.', true, true)]
    local procedure ItemJournal_OnAfterValidate_No(var Rec: Record "Item Journal Line"; var xRec: Record "Item Journal Line")
    begin
        if CheckAndRun(Rec.RecordId()) then
            Rec.Find('=');
    end;

    #endregion

    /// <summary>
    /// CheckAndRun.
    /// </summary>
    /// <param name="SourceRecordId">RecordId.</param>
    /// <returns>Return variable ReturnValue of type Boolean.</returns>
    local procedure CheckAndRun(SourceRecordId: RecordId) ReturnValue: Boolean;
    var
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        TransferLine: Record "Transfer Line";
        AssemblyLine: Record "Assembly Line";
        ItemJnlLine: Record "Item Journal Line";
        StockedAttributeDocEntryMgmt: Codeunit StockedAttributeDocEntryMgmt;
        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
        RecRef: RecordRef;
        TypeItemTxt: Label 'Item';
    begin
        if not StockedAttributeMgmt.IsEnabled() then
            exit;

        RecRef.Get(SourceRecordId);
        case RecRef.Number() of
            Database::"Sales Line":
                begin
                    RecRef.SetTable(SalesLine);
                    if not TestLine(Format(SalesLine.Type), SalesLine."No.", SalesLine."Variant Code") then
                        exit;
                end;
            Database::"Purchase Line":
                begin
                    RecRef.SetTable(PurchaseLine);
                    if not TestLine(Format(PurchaseLine.Type), PurchaseLine."No.", PurchaseLine."Variant Code") then
                        exit;
                end;
            Database::"Transfer Line":
                begin
                    RecRef.SetTable(TransferLine);
                    if not TestLine(TypeItemTxt, TransferLine."Item No.", TransferLine."Variant Code") then
                        exit;
                end;
            Database::"Assembly Line":
                begin
                    RecRef.SetTable(AssemblyLine);
                    if not TestLine(Format(AssemblyLine.Type), AssemblyLine."No.", AssemblyLine."Variant Code") then
                        exit;
                end;
            Database::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJnlLine);
                    if not TestLine(Format(ItemJnlLine.Type), ItemJnlLine."No.", ItemJnlLine."Variant Code") then
                        exit;
                end;
        end;
        StockedAttributeDocEntryMgmt.LaunchStockedAttributeConfigurator(RecRef);

        ReturnValue := true;
    end;

    /// <summary>
    /// TestLine.
    /// </summary>
    /// <param name="LineType">Text.</param>
    /// <param name="ItemNo">Code[20].</param>
    /// <param name="VariantCode">Code[10].</param>
    /// <returns>Return variable ReturnValue of type Boolean.</returns>
    local procedure TestLine(LineType: Text; ItemNo: Code[20]; VariantCode: Code[10]) ReturnValue: Boolean;
    var
        Item: Record Item;
        TypeItemTxt: Label 'Item';
        EmptyTxt: Label '';
    begin
        if LineType <> TypeItemTxt then
            exit;

        if ItemNo = EmptyTxt then
            exit;

        if VariantCode <> EmptyTxt then
            exit;

        Item.Get(ItemNo);
        if StrLen(Item.StockedAttributeTemplateCode) = 0 then
            exit;

        ReturnValue := true;
    end;
}