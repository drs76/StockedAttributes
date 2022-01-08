/// <summary>
/// TablePTEStkAttributeTemplate (ID 50106).
/// </summary>
table 50106 PTEStkAttributeTemplate
{
    Caption = 'Stocked Attribute Template';
    DataClassification = CustomerContent;

    fields
    {
        field(1; TemplateCode; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }

        field(2; Description; Text[2048])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(4; TemplateSetId; Integer)
        {
            Caption = 'Template Set ID';
            DataClassification = CustomerContent;
        }

        field(5; EntryPageType; Enum PTEStkAttributeEntryPageType)
        {
            Caption = 'Entry Page Type';
            DataClassification = CustomerContent;
            InitValue = Default;
        }
    }
    keys
    {
        key(PK; TemplateCode)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; TemplateCode, Description) { }
    }

}
