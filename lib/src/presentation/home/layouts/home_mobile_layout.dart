import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keycloack_integrations/src/data/model/property_model.dart';
import 'package:keycloack_integrations/src/data/model/user_model.dart';
import 'package:keycloack_integrations/src/presentation/home/widgets/property_card_mobile.dart';

class HomeMobileLayout extends StatelessWidget {
  const HomeMobileLayout({
    super.key,
    required this.user,
    required this.properties,
    required this.isLoading,
    required this.error,
    required this.searchController,
    required this.onSearch,
    required this.onRefresh,
  });

  final UserModel user;
  final List<PropertyModel> properties;
  final bool isLoading;
  final String? error;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, ${user.username}',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Encuentra tu hogar ideal',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Search bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Buscar por ciudad, país o nombre...',
                hintStyle: TextStyle(fontSize: 13.sp),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),

          SizedBox(height: 12.h),

          // Contador
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              '${properties.length} propiedades encontradas',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),

          SizedBox(height: 8.h),

          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 48.sp, color: Colors.grey),
            SizedBox(height: 12.h),
            Text(
              'Error al cargar propiedades',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 8.h),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48.sp, color: Colors.grey[400]),
            SizedBox(height: 12.h),
            Text(
              'No se encontraron propiedades',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
        itemCount: properties.length,
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemBuilder: (context, index) =>
            PropertyCardMobile(property: properties[index]),
      ),
    );
  }
}
