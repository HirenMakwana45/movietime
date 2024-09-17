import 'package:flutter/material.dart';
import 'package:movietime/extensions/app_text_field.dart';
import 'package:movietime/extensions/extension_util/context_extensions.dart';
import 'package:movietime/extensions/extension_util/int_extensions.dart';
import 'package:movietime/extensions/extension_util/widget_extensions.dart';
import 'package:movietime/extensions/widgets.dart';
import 'package:movietime/network/rest_api.dart';
import 'package:movietime/screens/detail_screen.dart';

import '../extensions/animatedList/animated_list_view.dart';
import '../extensions/common.dart';
import '../extensions/decorations.dart';
import '../models/upcoming_movies.dart';
import '../utils/app_common.dart';
import '../utils/app_images.dart';
import 'no_data_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController mSearch = TextEditingController();

  String? mSearchValue = "";
  bool _showClearButton = false;
  List<Results> resultList = [];
  bool iLoading = false;

  Future<void> getResultData() async {
    await searchApi(mSearchValue: mSearchValue).then((value) {
      Iterable it = value.results!;
      it.map((e) => resultList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      setState(() {});
    });
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return mSuffixTextFieldIconWidget(ic_search);
    }

    return IconButton(
      onPressed: () {
        mSearch.clear();
        mSearchValue = "";
        hideKeyboard(context);
        // getProductDataAPI();
      },
      icon: Icon(Icons.clear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('Search', context: context, showBack: false),
      body: SingleChildScrollView(
        child: Column(children: [
          AppTextField(
            controller: mSearch,
            textFieldType: TextFieldType.OTHER,
            isValidationRequired: false,
            autoFocus: false,
            suffix: _getClearButton(),
            decoration: defaultInputDecoration(context,
                isFocusTExtField: true, label: 'Search Movies...'),
            onChanged: (v) {
              mSearchValue = v;
              // appStore.setLoading(true);
              getResultData();
              setState(() {});
            },
          ),
          // mSearchValue.isEmptyOrNull
          //     ?
          resultList.isNotEmpty
              ? AnimatedListView(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: resultList.length,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            5.height,
                            Text(resultList[index].title.toString()),
                            Text(resultList[index]
                                .releaseDate
                                .toString()
                                .substring(0, 4)),
                            10.height,
                          ],
                        ).expand(),
                        Icon(Icons.arrow_forward_ios, size: 16).onTap(() {
                          DetailScreen(movieId:  resultList[index].id!).launch(context);
                        })
                      ],
                    );
                  },
                )
              : SizedBox(
                  height: context.height() * 0.6,
                  child: NoDataScreen(mTitle: 'No Movies Found')
                      .center()
                      .visible(!iLoading),
                )
          //     : Stack(
          //   children: [
          //     // mExceriseList().paddingTop(16),
          //     SizedBox(
          //       height: context.height() * 0.6,
          //       child: NoDataScreen(mTitle: 'No Movies Found').visible(resultList.isEmpty).center().visible(!iLoading),
          //     )
          //   ],
          // ),
        ]),
      ),
    ).paddingAll(16);
  }
}
