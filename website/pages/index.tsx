import type { NextPage } from "next";
import { useEffect } from "react";
import Head from "next/head";
import Latex from "react-latex-next";
import anime from "animejs";
import prism from "prismjs";
import "prismjs/components/prism-bash";
import "prismjs/plugins/command-line/prism-command-line.js";
import "prismjs/plugins/command-line/prism-command-line.css";

const GitHub = (props: any) => (
    <svg
        xmlns="http://www.w3.org/2000/svg"
        xmlnsXlink="http://www.w3.org/1999/xlink"
        viewBox="0 0 90 90"
        width="90px"
        height="90px"
        {...props}
    >
        <g id="GitHub">
            <path d="M 45 9 C 25.117188 9 9 25.117188 9 45 C 9 61.867188 20.617188 75.984375 36.277344 79.890625 C 36.109375 79.402344 36 78.839844 36 78.140625 L 36 71.988281 C 34.539062 71.988281 32.089844 71.988281 31.476562 71.988281 C 29.011719 71.988281 26.824219 70.929688 25.761719 68.960938 C 24.582031 66.773438 24.378906 63.429688 21.457031 61.382812 C 20.589844 60.703125 21.25 59.925781 22.246094 60.03125 C 24.09375 60.550781 25.621094 61.816406 27.0625 63.695312 C 28.496094 65.578125 29.171875 66.003906 31.851562 66.003906 C 33.148438 66.003906 35.09375 65.929688 36.925781 65.640625 C 37.90625 63.140625 39.609375 60.839844 41.6875 59.753906 C 29.699219 58.519531 23.980469 52.558594 23.980469 44.460938 C 23.980469 40.972656 25.464844 37.601562 27.988281 34.761719 C 27.160156 31.941406 26.117188 26.191406 28.304688 24 C 33.699219 24 36.960938 27.496094 37.742188 28.441406 C 40.429688 27.523438 43.382812 27 46.484375 27 C 49.59375 27 52.558594 27.523438 55.25 28.449219 C 56.023438 27.511719 59.289062 24 64.695312 24 C 66.890625 26.191406 65.839844 31.96875 65 34.78125 C 67.507812 37.617188 68.984375 40.980469 68.984375 44.460938 C 68.984375 52.550781 63.273438 58.511719 51.304688 59.75 C 54.597656 61.46875 57 66.300781 57 69.9375 L 57 78.140625 C 57 78.453125 56.929688 78.679688 56.894531 78.945312 C 70.921875 74.027344 81 60.707031 81 45 C 81 25.117188 64.882812 9 45 9 Z M 45 9 " />
        </g>
    </svg>
);

const Ceiphr = (props: any) => (
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" {...props}>
        <g id="Ceiphr">
            <path d="M0,128A128,128,0,1,0,128,0,128,128,0,0,0,0,128Zm166,37.26a12.8,12.8,0,0,1,12.8,12.8v1.14A12.8,12.8,0,0,1,166,192h-1.14a12.8,12.8,0,0,1-12.8-12.8v-1.14a12.8,12.8,0,0,1,12.8-12.8Zm-37.43,0a12.8,12.8,0,0,1,12.8,12.8v1.14a12.8,12.8,0,0,1-12.8,12.8h-1.14a12.8,12.8,0,0,1-12.8-12.8v-1.14a12.8,12.8,0,0,1,12.8-12.8Zm-37.43,0a12.8,12.8,0,0,1,12.8,12.8v1.14A12.8,12.8,0,0,1,91.14,192H90a12.8,12.8,0,0,1-12.8-12.8v-1.14A12.8,12.8,0,0,1,90,165.26ZM166,128a12.8,12.8,0,0,1,12.8,12.8v1.14a12.8,12.8,0,0,1-12.8,12.8h-1.14a12.8,12.8,0,0,1-12.8-12.8V140.8a12.8,12.8,0,0,1,12.8-12.8Zm-37.43-26.74a12.8,12.8,0,0,1,12.8,12.8v27.88a12.8,12.8,0,0,1-12.8,12.8h-1.14a12.8,12.8,0,0,1-12.8-12.8V114.06a12.8,12.8,0,0,1,12.8-12.8Zm-37.43,0a12.8,12.8,0,0,1,12.8,12.8v27.88a12.8,12.8,0,0,1-12.8,12.8H90a12.8,12.8,0,0,1-12.8-12.8V114.06A12.8,12.8,0,0,1,90,101.26ZM128.57,64a12.8,12.8,0,0,1,12.8,12.8v1.14a12.8,12.8,0,0,1-12.8,12.8h-1.14a12.8,12.8,0,0,1-12.8-12.8V76.8A12.8,12.8,0,0,1,127.43,64Z" />
        </g>
    </svg>
);

const Home: NextPage = () => {
    const codeSample = `sh -c "$(curl -sL https://ceiphr.io/reserver/install)"
Install reserver to /usr/local/bin? Root required. [y/N]: y
Done. Run 'reserver' to reserve some space!
reserver
Reserving 5GB of space...
Reservation complete!
reserver
Reservation file already exists. Delete? [y/N]: y
Reservation removed. Good luck!`;

    useEffect(() => {
        prism.highlightAll();
        anime({
            targets: ".slide-in",
            translateY: [20, 0],
            opacity: [0, 1],
            delay: anime.stagger(150, { start: 200 }),
            duration: 1000,
            easing: "easeOutQuart",
        });
    }, []);

    return (
        <div>
            <Head>
                <title>Reserver</title>
                <meta
                    name="description"
                    content="A very mild contingency plan for servers that run out of space. "
                />
                <link rel="icon" href="/reserver/favicon.ico" />
            </Head>

            <main className="p-5 md:my-12 max-w-3xl mx-auto">
                <div className="slide-in flex justify-between">
                    <h1 className="text-5xl leading-snug">
                        <Latex>{"$\\R \\text{eserver}$"}</Latex>
                    </h1>
                    <div className="flex flex-row space-x-2">
                        <a
                            href="https://github.com/ceiphr/reserver"
                            className="text-black dark:text-white button rounded-md fill-current h-min my-3"
                            aria-label="GitHub"
                        >
                            <GitHub className="p-2 h-10 w-10" />
                        </a>
                        <a
                            href="https://ceiphr.com/"
                            className="text-black dark:text-white button rounded-md fill-current h-min my-3"
                            aria-label="Ceiphr"
                        >
                            <Ceiphr className="p-2.5 h-10 w-10" />
                        </a>
                    </div>
                </div>
                <p className="slide-in text-xl text-stone-500 dark:text-stone-400 italic -mt-2 mb-6">
                    /rə&apos;zərvər/
                </p>
                <div className="text-xl space-y-5">
                    <p className="slide-in">
                        A <span className="italic">very mild</span> contingency
                        plan for servers that run out of space. Based on this
                        great article by Brian Schrader:{" "}
                        <a
                            href="https://brianschrader.com/archive/why-all-my-servers-have-an-8gb-empty-file/"
                            rel="noreferrer"
                            target="_blank"
                        >
                            Why All My Servers Have An 8gb Empty File
                        </a>
                        .
                    </p>
                    <p className="slide-in">
                        Just like Schrader does in the article, this script will
                        reserve space on a server, so, you can delete it later.
                    </p>
                    <p className="slide-in">
                        Specifically, when your server runs out of space, you
                        can remove the reservation file this script produces so
                        that the server will hopefully have enough space to
                        function again while you try to fix whatever caused the
                        issue.
                    </p>
                    <p className="slide-in">
                        You should always use monitoring software and or SaaS
                        offerings such as{" "}
                        <a
                            href="https://www.datadoghq.com/"
                            rel="noreferrer"
                            target="_blank"
                        >
                            Datadog
                        </a>{" "}
                        to monitor disk usage on your servers. That is the tool
                        that will <span className="italic">really</span> help
                        you mitigate this potential problem. Think of Reserver
                        as a sidekick. It&apos;s simple to use and is there if
                        your primary tools somehow fail. It is a{" "}
                        <span className="italic">mild</span> contingency plan if
                        you can spare the disk space.
                    </p>
                    <h2 className="slide-in text-3xl">
                        Installation & Basic Usage
                    </h2>
                    <pre
                        className="slide-in command-line selection:bg-slate-200 dark:selection:bg-slate-700"
                        data-user="user"
                        data-host="remotehost"
                        data-output="2-3, 5-6, 8-9"
                    >
                        <code className="language-bash">{codeSample}</code>
                    </pre>
                    <h2 className="slide-in text-3xl">Resources</h2>
                    <ul className="slide-in list-disc ml-5">
                        <li>
                            <a href="https://github.com/ceiphr/reserver#usage">
                                Documentation
                            </a>
                        </li>
                        <li>
                            <a href="https://github.com/ceiphr/reserver/blob/main/reserver.sh">
                                Reserver Source Code
                            </a>
                        </li>
                        <li>
                            <a href="https://github.com/ceiphr/reserver/blob/main/website/public/install">
                                Installation Script Source Code
                            </a>
                        </li>
                        <li>
                            <a href="https://github.com/ceiphr/reserver/tree/main/website">
                                Website Source Code
                            </a>
                        </li>
                    </ul>
                    <footer className="slide-in">
                        <p>
                            Copyright © 2022 Ari Birnbaum (
                            <a href="https://ceiphr.com/">Ceiphr</a>).
                        </p>
                        <p>
                            Reserver, its installation script and this website
                            are all{" "}
                            <a href="https://github.com/ceiphr/reserver/blob/main/LICENSE">
                                MIT licensed
                            </a>
                            .
                        </p>
                    </footer>
                </div>
            </main>
        </div>
    );
};

export default Home;
