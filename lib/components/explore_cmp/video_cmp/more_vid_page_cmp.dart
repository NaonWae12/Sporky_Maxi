import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sporky_maxi/components/globals/card/globals_card_outlined.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/constants/api_endpoints.dart';
import 'package:sporky_maxi/components/globals/text/text_style.dart';
import 'package:sporky_maxi/core/utils/secure_storage_service.dart';

import '../../../views/explore_page/video_section/video_fav.dart';
import '../../globals/form/search_input.dart';
import 'content_vid_vert2.dart';
import '../../globals/filter/category_filter_chips_horizontal.dart';
import '../../globals/filter/filter_content_button.dart';

class MoreVidPageCmp extends StatefulWidget {
  final String searchQuery;

  const MoreVidPageCmp({
    super.key,
    this.searchQuery = '',
  });

  @override
  State<MoreVidPageCmp> createState() => _MoreVidPageCmpState();
}

class _MoreVidPageCmpState extends State<MoreVidPageCmp> {
  int _selectedIndex = 0;
  List<String> _selectedFiltersFromBottomSheet = [];

  // Topics dari API: index 0 selalu 'Semua'
  List<Map<String, dynamic>> _topics = [
    {'id': null, 'name': 'Semua'}
  ];
  bool _topicsLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  Future<void> _fetchTopics() async {
    try {
      final token = await SecureStorageService.getToken();
      final headers = <String, String>{'Accept': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] =
            token.startsWith('Bearer ') ? token : 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse(ApiEndpoints.topics),
        headers: headers,
      );

      debugPrint('[MoreVidPageCmp] topics status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final dataNode = body['data'];
        if (dataNode is List) {
          final fetchedTopics = dataNode
              .whereType<Map<String, dynamic>>()
              .map((t) => {
                    'id': t['id'] as int?,
                    'name': t['name']?.toString() ?? '',
                  })
              .where((t) => (t['name'] as String).isNotEmpty)
              .toList();

          if (mounted) {
            setState(() {
              _topics = [
                {'id': null, 'name': 'Semua'},
                ...fetchedTopics,
              ];
            });
          }
        }
      }
    } catch (e) {
      debugPrint('[MoreVidPageCmp] Error fetching topics: $e');
    } finally {
      if (mounted) {
        setState(() {
          _topicsLoading = false;
        });
      }
    }
  }

  List<String> get _topicNames =>
      _topics.map((t) => t['name'] as String).toList();

  Map<String, dynamic>? get _selectedTopic {
    if (_selectedIndex == 0) return null;
    if (_selectedIndex < _topics.length) {
      return _topics[_selectedIndex];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          _topicsLoading
              ? const SizedBox(
                  height: 36,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : CategoryFilterChipsHorizontal(
                  categories: _topicNames,
                  selectedIndex: _selectedIndex,
                  onSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _selectedFiltersFromBottomSheet.isNotEmpty
                      ? Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: _selectedFiltersFromBottomSheet
                              .map(
                                (filter) => GlobalsCardOutlined(
                                  height: 24,
                                  borderColor: Colors.transparent,
                                  backgroundColor: AppColors.secondary2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(filter,
                                          style: AppTextStyles.list1Regular(
                                              AppColors.base5)),
                                      IconButton(
                                        icon: const Icon(Icons.close,
                                            size: 15, color: AppColors.base5),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          setState(() {
                                            _selectedFiltersFromBottomSheet
                                                .remove(filter);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : const SizedBox(),
                ),
                const SizedBox(width: 8),
                FilterContentButton(
                  categories: const ['sdfg', 'adfads'],
                  title: 'Urutkan Berdasarkan',
                  onFilterApplied: (selected) {
                    setState(() {
                      _selectedFiltersFromBottomSheet = selected;
                    });
                  },
                ),
              ],
            ),
          ),

          ContentVidVert2(
            searchQuery: widget.searchQuery,
            selectedTopic: _selectedTopic,
          ),
        ],
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  TextEditingController searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: MediaQuery.of(context).size.width,
        leading: SearchInput(
          onLeadingPressed: () => Navigator.pop(context),
          showLeadingIcon: true,
          controller: searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          onHeartPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const VideoFav()));
          },
        ),
      ),
      body: MoreVidPageCmp(searchQuery: _searchQuery),
    );
  }
}
