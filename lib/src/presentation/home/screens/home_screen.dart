import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keycloack_integrations/src/core/services/property_service.dart';
import 'package:keycloack_integrations/src/data/model/property_model.dart';
import 'package:keycloack_integrations/src/data/model/user_model.dart';
import 'package:keycloack_integrations/src/presentation/home/layouts/home_mobile_layout.dart';
import 'package:keycloack_integrations/src/presentation/home/layouts/home_web_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PropertyService _propertyService = PropertyService();
  final TextEditingController _searchController = TextEditingController();

  List<PropertyModel> _properties = [];
  List<PropertyModel> _filtered = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProperties() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final properties = await _propertyService.getProperties();
      setState(() {
        _properties = properties;
        _filtered = properties;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterProperties(String query) {
    setState(() {
      _filtered = _properties.where((p) {
        final q = query.toLowerCase();
        return p.name.toLowerCase().contains(q) ||
            p.city.toLowerCase().contains(q) ||
            p.country.toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return HomeWebLayout(
        user: widget.user,
        properties: _filtered,
        isLoading: _isLoading,
        error: _error,
        searchController: _searchController,
        onSearch: _filterProperties,
        onRefresh: _loadProperties,
      );
    }

    return HomeMobileLayout(
      user: widget.user,
      properties: _filtered,
      isLoading: _isLoading,
      error: _error,
      searchController: _searchController,
      onSearch: _filterProperties,
      onRefresh: _loadProperties,
    );
  }
}
