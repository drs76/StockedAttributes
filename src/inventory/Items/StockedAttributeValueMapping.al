// table 50105 StockedAttributeValueMapping
// {
//     Caption = 'Item Stocked Attribute Value Mapping';

//     fields
//     {
//         field(1; "Item No."; Code[20])
//         {
//             Caption = 'Item No.';
//             TableRelation = Item;
//         }
//         field(2; "Variant Code"; Code[10])
//         {
//             Caption = 'Variant Code';
//             TableRelation = "Item Variant".Code where ("Item No." = field("Item No."));
//         }
//         field(3; StockedAttributeID; Integer)
//         {
//             Caption = 'Item Attribute ID';
//             TableRelation = "Item Attribute";
//         }
//         field(4; StockedAttributeValueID; Integer)
//         {
//             Caption = 'Item Attribute Value ID';
//             TableRelation = "Item Attribute Value".ID;
//         }
//     }

//     keys
//     {
//         key(PK; "Variant Code", "Item No.", StockedAttributeID, StockedAttributeValueID)
//         {
//             Clustered = true;
//         }
//     }

//     fieldgroups
//     {
//     }

//     trigger OnDelete()
//     var
//         ItemAttribute: Record "Item Attribute";
//         ItemAttributeValue: Record "Item Attribute Value";
//         ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
//     begin
//         ItemAttribute.Get("Item Attribute ID");
//         if ItemAttribute.Type = ItemAttribute.Type::Option then
//             exit;

//         if not ItemAttributeValue.Get("Item Attribute ID", "Item Attribute Value ID") then
//             exit;

//         ItemAttributeValueMapping.SetRange("Item Attribute ID", "Item Attribute ID");
//         ItemAttributeValueMapping.SetRange("Item Attribute Value ID", "Item Attribute Value ID");
//         if ItemAttributeValueMapping.Count <> 1 then
//             exit;

//         ItemAttributeValueMapping := Rec;
//         if ItemAttributeValueMapping.Find then
//             ItemAttributeValue.Delete();
//     end;

//     procedure RenameItemAttributeValueMapping(PrevNo: Code[20]; NewNo: Code[20])
//     var
//         ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
//     begin
//         SetRange("Table ID", DATABASE::Item);
//         SetRange("No.", PrevNo);
//         if FindSet then
//             repeat
//                 ItemAttributeValueMapping := Rec;
//                 ItemAttributeValueMapping.Rename("Table ID", NewNo, "Item Attribute ID");
//             until Next = 0;
//     end;
// }

