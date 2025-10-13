import 'package:flutter/material.dart';

class DashboardFooter extends StatelessWidget {
  final Color primaryColor;

  const DashboardFooter({
    super.key,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: primaryColor,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'CORAÇÃO GENEROSO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abrindo Instagram...')),
                  );
                },
                child: const Text(
                  '@coracaogeneroso',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abrindo Facebook...')),
                  );
                },
                child: const Text(
                  'Facebook',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ligando para (11) 99999-9999...')),
                  );
                },
                child: const Text(
                  '(11) 99999-9999',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '© 2025 Coração Generoso',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}