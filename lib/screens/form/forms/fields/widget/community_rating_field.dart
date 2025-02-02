part of '../fields.dart';

class CommunityRatingField extends StatelessWidget {
  final FormGroup form;
  const CommunityRatingField({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<double>(
        formControlName: FieldsEnum.COMMUNITYRATING.name,
        validationMessages: (control) => {
              ValidationMessage.required:
                  'The original title must not be empty',
            },
        keyboardType: TextInputType.number,
        onSubmitted: () => form.focus(FieldsEnum.OVERVIEW.name),
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(labelText: 'Community rating'));
  }
}
