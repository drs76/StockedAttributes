/// <summary>
/// Table StockedAttributeTemplate (ID 50106).
/// </summary>
table 50106 StockedAttributeTemplate
{
    Caption = 'StockedAttributeTemplate';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[2048])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(4; "Template Set ID"; Integer)
        {
            Caption = 'Template Set ID';
            DataClassification = CustomerContent;
        }
        field(5; EntryPageType; Enum StockedAttributeEntryPageType)
        {
            Caption = 'Entry Page Type';
            DataClassification = CustomerContent;
            InitValue = Default;
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
