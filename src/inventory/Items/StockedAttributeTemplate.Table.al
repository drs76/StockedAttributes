table 50106 StockedAttributeTemplate
{
    Caption = 'StockedAttributeTemplate';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = SystemMetadata;
        }
        field(2; Description; Text[2048])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(4; "Template Set ID"; Integer)
        {
            Caption = 'Template Set ID';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description) { }
    }

}
