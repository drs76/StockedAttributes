/// <summary>
/// TablePTEStkAttributeTemplateTree (ID 50103).
/// </summary>
table 50103 PTEStkAttributeTemplateTree
{
    Caption = 'Stocked Attribute Template';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Parent Template Set ID"; Integer)
        {
            Caption = 'Parent Template Set ID';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; "Template Attribute ID"; Integer)
        {
            Caption = 'Template Attribute ID';
            DataClassification = CustomerContent;
        }
        field(3; "Template Value ID"; Integer)
        {
            Caption = 'Template Value ID';
            DataClassification = CustomerContent;
        }
        field(4; "Template Set ID"; Integer)
        {
            Caption = 'Template Set ID';
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; "In Use"; Boolean)
        {
            caption = 'In Use';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Parent Template Set ID", "Template Attribute ID", "Template Value ID")
        {
            Clustered = true;
        }
    }
}

