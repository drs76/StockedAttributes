table 50105 StockedAttributeDocEntryBuffer
{
    Caption = 'Stocked Attribute Entry Buffer';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; EntryNo; Integer)
        {
            Caption = 'Entry No';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = SystemMetadata;
        }
        field(3; "Variant Code"; Code[20])
        {
            Caption = 'Variant Code';
            DataClassification = SystemMetadata;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = lookup (Item.Description where("No." = field("Item No.")));
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
        }
        field(6; UnitofMeasureCode; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = SystemMetadata;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(7; LocationCode; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = SystemMetadata;
            TableRelation = Location;
        }

        field(8; "Attribute Filter 1"; Integer)
        {
            Caption = 'Attribute Filter 1';
            FieldClass = FlowFilter;
        }
        field(9; "Attribute Filter 2"; Integer)
        {
            Caption = 'Attribute Filter 2';
            FieldClass = FlowFilter;
        }
        field(10; "Attribute Filter 3"; Integer)
        {
            Caption = 'Attribute Filter 3';
            FieldClass = FlowFilter;
        }
        field(11; "Attribute Filter 4"; Integer)
        {
            Caption = 'Attribute Filter 4';
            FieldClass = FlowFilter;
        }
        field(12; "Attribute Filter 5"; Integer)
        {
            Caption = 'Attribute Filter 5';
            FieldClass = FlowFilter;
        }
        field(13; "Attribute Filter 6"; Integer)
        {
            Caption = 'Attribute Filter 6';
            FieldClass = FlowFilter;
        }
        field(14; "Attribute Filter 7"; Integer)
        {
            Caption = 'Attribute Filter 7';
            FieldClass = FlowFilter;
        }
        field(15; "Attribute Filter 8"; Integer)
        {
            Caption = 'Attribute Filter 8';
            FieldClass = FlowFilter;
        }
        field(16; "Attribute Filter 9"; Integer)
        {
            Caption = 'Attribute Filter 9';
            FieldClass = FlowFilter;
        }
        field(17; "Attribute Filter 10"; Integer)
        {
            Caption = 'Attribute Filter 10';
            FieldClass = FlowFilter;
        }
        field(18; "Attribute Filter 11"; Integer)
        {
            Caption = 'Attribute Filter 11';
            FieldClass = FlowFilter;
        }
        field(19; "Attribute Filter 12"; Integer)
        {
            Caption = 'Attribute Filter 12';
            FieldClass = FlowFilter;
        }
        field(20; "Attribute Filter 13"; Integer)
        {
            Caption = 'Attribute Filter 13';
            FieldClass = FlowFilter;
        }
        field(21; "Attribute Filter 14"; Integer)
        {
            Caption = 'Attribute Filter 14';
            FieldClass = FlowFilter;
        }
        field(22; "Attribute Filter 15"; Integer)
        {
            Caption = 'Attribute Filter 15';
            FieldClass = FlowFilter;
        }
        field(23; "Attribute Filter 16"; Integer)
        {
            Caption = 'Attribute Filter 16';
            FieldClass = FlowFilter;
        }
        field(24; "Attribute Filter 17"; Integer)
        {
            Caption = 'Attribute Filter 17';
            FieldClass = FlowFilter;
        }
        field(25; "Attribute Filter 18"; Integer)
        {
            Caption = 'Attribute Filter 18';
            FieldClass = FlowFilter;
        }
        field(26; "Attribute Filter 19"; Integer)
        {
            Caption = 'Attribute Filter 19';
            FieldClass = FlowFilter;
        }
        field(27; "Attribute Filter 20"; Integer)
        {
            Caption = 'Attribute Filter 20';
            FieldClass = FlowFilter;
        }
        field(28; "Template Filter"; Integer)
        {
            Caption = 'Attribute Template Filter';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }

}
