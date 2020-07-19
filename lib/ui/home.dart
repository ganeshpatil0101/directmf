import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:DirectMF/common/calendar.dart';
import 'package:DirectMF/main.dart';
import 'package:DirectMF/redux/actions.dart';
import 'package:DirectMF/redux/selectors.dart';
import 'package:DirectMF/services/mf_api_service.dart';
import 'package:DirectMF/ui/common/progress_indicator.dart';
import 'package:DirectMF/ui/drawer.dart';
import 'package:DirectMF/ui/entries/add_entry_page.dart';
import 'package:DirectMF/ui/entries/entries_page.dart';
import 'package:DirectMF/ui/mf/addEditMfPage.dart';
import 'package:DirectMF/ui/mf/addMf.dart';
import 'package:DirectMF/ui/mf/entity_mf_list.dart';
import 'package:DirectMF/ui/mf/upload_pdf.dart';
import 'package:DirectMF/ui/statistics/statistics_page.dart';

class HomeScreen extends StatelessWidget {
  static const route = '/home';

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  bool enableRefresh = true;
  bool showLoading = false;
  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var popup = BeautifulPopup(
      context: context,
      template: TemplateBlueRocket,
    );
    var infoMsg =
        BeautifulPopup(context: context, template: TemplateNotification);
    var successMsg =
        BeautifulPopup(context: context, template: TemplateSuccess);
    return Scaffold(
      drawer: HomeDrawer(),
      extendBody: true,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: Text('Smart Direct MF'),
        actions: <Widget>[
          IconButton(
              disabledColor: Colors.grey,
              iconSize: 28.0,
              icon: Icon(Icons.refresh),
              onPressed: () {
                print("reload MF");
                // Get previous last nav sync date and compaire with current
                // if not matched then update the lastNavSynch in DB
                // the dispatch refresh all nav price request
                // if lastlastnav date and todays date same then nothing will happen

                // TODO Store and get data from sharedspace
                //DateTime ls = DateTime.parse(MfApiService.getStoredLastSync());
                //print(ls);
                DateTime lastSync = getLastNavSync(globalStore.state);
                if (isLastSynchPrev(lastSync)) {
                  print(" Nav price is updated no need to update again");
                  infoMsg.show(
                      title: "Info",
                      content: "Nav price is updated for today",
                      actions: [
                        infoMsg.button(
                          label: 'OK',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ]);
                } else {
                  print("Old Nav Price Need to Update with current Nav");
                  setState(() {
                    this.showLoading = true;
                  });
                  //globalStore.dispatch(LastNavSync(DateTime.now()));
                  MfApiService.updateAllMfNavPrice().then((res) {
                    print("=====> Updated All Nav Price Successfully ...");
                    setState(() {
                      this.showLoading = false;
                    });
                    successMsg.show(
                        title: "Done!",
                        content:
                            "All Mutual Fund's Nav Price Updated Successfully",
                        actions: [
                          successMsg.button(
                              label: 'OK',
                              onPressed: () {
                                Navigator.of(context).pop();
                              })
                        ]);
                  }).catchError((e) {
                    print(e);
                  });
                }
              })
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          //EntriesPage(),
          (showLoading) ? PaddedCircularProgressIndicator() : EntityMfList(),
          StatisticsPage()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Upload',
          isExtended: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Icon(Icons.add),
          //onPressed: () => Navigator.pushNamed(context, AddExpensePage.route),
          onPressed: () => {
                popup.show(
                  title: 'Auto OR Manual',
                  content:
                      'Do you want to upload a CAMS CDSL / NSDL  statement \n OR \n create Mutual Fund Manually.',
                  actions: [
                    popup.button(
                      label: 'Upload',
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, UploadPdf.route);
                      },
                    ),
                    popup.button(
                        label: 'Manually',
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, AddEditMfPage.route);
                        })
                  ],
                )
              }),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.receipt)),
              Tab(icon: Icon(Icons.insert_chart))
            ],
            controller: _tabController,
            labelColor: Colors.indigo,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.blueGrey,
          ),
        ),
      ),
    );
  }
}
