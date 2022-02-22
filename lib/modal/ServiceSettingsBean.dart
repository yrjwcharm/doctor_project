class ServiceSettingsBean{
   String _icon;
   String _title;
   String _subTitle;
   String _detailTitle;
   int _status;

   String get icon => _icon;

  set icon(String value) {
    _icon = value;
  }

   ServiceSettingsBean(
      this._icon, this._title, this._subTitle, this._detailTitle, this._status);

   String get title => _title;

   int get status => _status;

  set status(int value) {
    _status = value;
  }

  String get detailTitle => _detailTitle;

  set detailTitle(String value) {
    _detailTitle = value;
  }

  String get subTitle => _subTitle;

  set subTitle(String value) {
    _subTitle = value;
  }

  set title(String value) {
    _title = value;
  }
}