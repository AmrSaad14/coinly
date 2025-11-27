import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/features/home/logic/notifications_cubit.dart';
import 'package:coinly/features/home/logic/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('الإشعارات'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final hasUnreadNotifications =
                    state is NotificationsLoaded &&
                    state.notifications.any((n) => n.readAt == null);
                final isLoading = state is NotificationsLoading;

                return IconButton(
                  icon: isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.done_all,
                          color: hasUnreadNotifications
                              ? null
                              : AppColors.neutral400,
                        ),
                  onPressed: isLoading || !hasUnreadNotifications
                      ? null
                      : () {
                          context
                              .read<NotificationsCubit>()
                              .markAllNotificationsRead();
                        },
                );
              },
            ),
          ],
        ),
        body: BlocListener<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: const Color(0xFF2A9578),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } else if (state is NotificationsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is NotificationsError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.message,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<NotificationsCubit>()
                              .loadNotifications();
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }

              if (state is NotificationsLoaded) {
                if (state.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 64.sp,
                          color: AppColors.neutral400,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'لا توجد إشعارات',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.neutral400,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<NotificationsCubit>().loadNotifications();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10.h);
                    },
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = state.notifications[index];
                      final isRead = notification.readAt != null;

                      return Container(
                        width: 340.w,
                        decoration: BoxDecoration(
                          color: isRead
                              ? AppColors.neutral100
                              : AppColors.primary500.withAlpha(20),
                          borderRadius: BorderRadius.circular(8.r),
                          border: isRead
                              ? null
                              : Border.all(
                                  color: AppColors.primary500.withAlpha(100),
                                  width: 1,
                                ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          leading: Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary500.withAlpha(70),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.message_outlined,
                              color: AppColors.primary500,
                              size: 20.sp,
                            ),
                          ),
                          title: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: isRead
                                  ? FontWeight.w500
                                  : FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4.h),
                              Text(
                                notification.body,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.neutral600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _formatDate(notification.createdAt),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.neutral400,
                                ),
                              ),
                            ],
                          ),
                          trailing: !isRead
                              ? Container(
                                  width: 8.w,
                                  height: 8.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary500,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'الآن';
          }
          return 'منذ ${difference.inMinutes} دقيقة';
        }
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays == 1) {
        return 'أمس';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} أيام';
      } else {
        final year = date.year.toString();
        final month = date.month.toString().padLeft(2, '0');
        final day = date.day.toString().padLeft(2, '0');
        return '$year-$month-$day';
      }
    } catch (e) {
      return dateString;
    }
  }
}
