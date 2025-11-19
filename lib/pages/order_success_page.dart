import 'package:flutter/material.dart';

class OrderSuccessPage extends StatefulWidget {
  const OrderSuccessPage({super.key});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController pizzaController;
  late AnimationController checkController;

  late Animation<double> pizzaDrop;
  late Animation<double> pizzaFadeOut;
  late Animation<double> checkRise;
  late Animation<double> checkFade;

  bool showPizza = true;

  @override
  void initState() {
    super.initState();

    pizzaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    pizzaDrop = Tween<double>(begin: -150, end: 0).animate(
      CurvedAnimation(parent: pizzaController, curve: Curves.easeOutBack),
    );

    pizzaFadeOut = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: pizzaController,
        curve: const Interval(0.7, 1, curve: Curves.easeOut),
      ),
    );

    checkRise = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: checkController, curve: Curves.easeOutBack),
    );

    checkFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: checkController, curve: Curves.easeIn));

    pizzaController.forward().whenComplete(() {
      setState(() => showPizza = false);
      checkController.forward();
    });
  }

  @override
  void dispose() {
    pizzaController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // ⬅️⬅️⬅️ INI KUNCI UTAMA BIAR BENER² TENGAH
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (showPizza)
                    AnimatedBuilder(
                      animation: pizzaController,
                      builder: (_, __) {
                        return Opacity(
                          opacity: pizzaFadeOut.value,
                          child: Transform.translate(
                            offset: Offset(0, pizzaDrop.value),
                            child: const Text(
                              "🍕",
                              style: TextStyle(fontSize: 90),
                            ),
                          ),
                        );
                      },
                    ),

                  AnimatedBuilder(
                    animation: checkController,
                    builder: (_, __) {
                      return Opacity(
                        opacity: checkFade.value,
                        child: Transform.translate(
                          offset: Offset(0, checkRise.value),
                          child: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 90,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              AnimatedBuilder(
                animation: checkController,
                builder: (_, __) {
                  return Opacity(
                    opacity: checkFade.value,
                    child: Column(
                      children: const [
                        Text(
                          "Pesanan Berhasil!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Terima kasih telah memesan 🍕",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              AnimatedBuilder(
                animation: checkController,
                builder: (_, __) {
                  return Opacity(
                    opacity: checkFade.value,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: const Text(
                        "Kembali ke Beranda",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
