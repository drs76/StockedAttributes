/// <summary>
/// TablePTEStkAttributeTemplateTree (ID 50103).
/// </summary>
table 50103 PTEStkAttributeTemplateTree
{
    Caption = 'Stocked Attribute Template';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ParentTemplateSetId; Integer)
        {
            Caption = 'Parent Template Set ID';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; TemplateAttributeId; Integer)
        {
            Caption = 'Template Attribute ID';
            DataClassification = CustomerContent;
        }
        field(3; TemplateValueId; Integer)
        {
            Caption = 'Template Value ID';
            DataClassification = CustomerContent;
        }
        field(4; TemplateSetID; Integer)
        {
            Caption = 'Template Set ID';
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; InUse; Boolean)
        {
            caption = 'In Use';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; ParentTemplateSetId, TemplateAttributeId, TemplateValueId)
        {
            Clustered = true;
        }
    }
}

