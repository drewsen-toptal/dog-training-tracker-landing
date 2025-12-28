import Image from "next/image";

const screenshots = [
  {
    title: "Progress Tracking",
    description: "Visual charts showing your dog's training progress over time",
    image: "/screenshots/progress-dashboard.png",
  },
  {
    title: "Built-in Clicker",
    description: "Professional clicker training tool always at your fingertips",
    image: "/screenshots/clicker.png",
  },
  {
    title: "Command Library",
    description: "Step-by-step guides for teaching essential commands",
    image: "/screenshots/command-library.png",
  },
];

export function AppScreenshots() {
  return (
    <section id="screenshots" className="py-16 md:py-20 lg:py-24 bg-background">
      <div className="container mx-auto px-4 md:px-6 lg:px-8">
        {/* Section Header */}
        <div className="mx-auto mb-12 max-w-2xl text-center md:mb-16">
          <h2 className="text-2xl font-bold tracking-tight md:text-3xl lg:text-4xl">
            Everything You Need in One App
          </h2>
          <p className="mt-4 text-muted-foreground">
            Simple, powerful tools designed for real dog training
          </p>
        </div>

        {/* Screenshots Grid - Fixed alignment and centering */}
        <div className="grid gap-12 md:grid-cols-3 md:gap-8 lg:gap-10 max-w-6xl mx-auto items-start">
          {screenshots.map((screen, index) => (
            <div key={index} className="flex flex-col items-center">
              {/* Phone Mockup Container - Fixed for alignment */}
              <div className="relative w-full max-w-[260px] mx-auto mb-6">
                {/* Subtle glow effect for depth */}
                <div className="absolute inset-0 bg-gradient-to-b from-primary/5 to-transparent rounded-[3rem] blur-xl scale-95 -z-10" />

                {/* Phone Mockup with Real Screenshot */}
                <div className="relative w-full aspect-[9/19.5] rounded-[2.5rem] bg-gray-900 shadow-2xl overflow-hidden border-[8px] border-gray-900 ring-1 ring-gray-800/30">
                  {/* Dynamic Island - compact pill shape like iPhone 14/15 Pro */}
                  <div className="absolute top-3 left-1/2 -translate-x-1/2 w-[62px] h-[18px] bg-black rounded-full z-20" />

                  {/* Screenshot Image - Scale and translate to hide iOS status bar */}
                  <div className="relative w-full h-full overflow-hidden rounded-[2rem] bg-gray-100">
                    <Image
                      src={screen.image}
                      alt={`${screen.title} screenshot`}
                      fill
                      className="object-cover scale-[1.12] translate-y-[5%]"
                      sizes="(max-width: 768px) 260px, (max-width: 1024px) 33vw, 260px"
                      quality={90}
                    />
                  </div>

                  {/* Home Indicator */}
                  <div className="absolute bottom-2 left-1/2 -translate-x-1/2 w-28 h-1 bg-white/40 rounded-full z-20" />
                </div>
              </div>

              {/* Description - Consistent spacing */}
              <div className="text-center max-w-[260px]">
                <h3 className="text-lg font-semibold text-foreground mb-2 leading-tight">
                  {screen.title}
                </h3>
                <p className="text-sm text-muted-foreground leading-relaxed">
                  {screen.description}
                </p>
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
