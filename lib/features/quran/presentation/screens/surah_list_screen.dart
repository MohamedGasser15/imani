import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imani/features/quran/providers/quran_provider.dart';
import 'package:imani/features/quran/presentation/screens/surah_detail_screen.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quranProvider = Provider.of<QuranProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر السورة'),
        centerTitle: true,
      ),
      body: quranProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : quranProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('حدث خطأ: ${quranProvider.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => quranProvider.preload(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : quranProvider.surahs.isEmpty
                  ? const Center(child: Text('لا توجد سور'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: quranProvider.surahs.length,
                      itemBuilder: (context, index) {
                        final surah = quranProvider.surahs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primary,
                              child: Text(
                                '${surah.number}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              surah.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Scheherazade',
                              ),
                            ),
                            subtitle: Text(
                              '${surah.englishName} • ${surah.revelationType} • ${surah.numberOfAyahs} آيات',
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SurahDetailScreen(surah: surah),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}